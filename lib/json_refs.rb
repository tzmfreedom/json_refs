require 'json_refs/version'
require 'json_refs/dereference_handler'

module JsonRefs
  def self.call(doc, options = {})
    Dereferencer.new(doc, options).call
  end

  class Dereferencer
    def initialize(doc, options = {})
      @doc = doc
      @options = options
    end

    def call(doc = @doc, keys = [])
      if doc.is_a?(Array)
        doc.each_with_index do |value, idx|
          call(value, keys + [idx])
        end
      elsif doc.is_a?(Hash)
        if doc.has_key?('$ref')
          dereference(keys, doc['$ref'])
        else
          doc.each do |key, value|
            call(value, keys + [key])
          end
        end
      end
      doc
    end

    private

    def dereference(paths, referenced_path)
      key = paths.pop
      target = paths.inject(@doc) do |obj, key|
        obj[key]
      end
      target[key] = referenced_value(referenced_path)
    end

    def referenced_value(referenced_path)
      if referenced_path =~ /^#/
        dereference_local(referenced_path)
      else
        dereference_file(referenced_path)
      end
    end

    def dereference_local(referenced_path)
      if @options[:resolve_local_ref] === false
        return { '$ref': referenced_path }
      end

      klass = JsonRefs::DereferenceHandler::Local
      klass.new(path: referenced_path, doc: @doc).call
    end

    def dereference_file(referenced_path)
      if @options[:resolve_file_ref] === false
        return { '$ref': referenced_path }
      end

      klass = JsonRefs::DereferenceHandler::File

      # Checking for "://" in a URL like http://something.com so as to determine if it's a remote URL
      remote_uri = referenced_path =~ /:\/\//

      if remote_uri
        klass.new(path: referenced_path, doc: @doc).call
      else
        recursive_deference(referenced_path, klass)
      end
    end

    def recursive_deference(referenced_path, klass)
      directory = File.dirname(referenced_path)
      filename = File.basename(referenced_path)
      
      dereferenced_doc = {}
      Dir.chdir(directory) do
        referenced_doc = klass.new(path: filename, doc: @doc).call
        dereferenced_doc = Dereferencer.new(referenced_doc, @options).call
      end
      dereferenced_doc
    end
  end
end
