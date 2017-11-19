require 'open-uri'
require 'json'
require 'yaml'

module JsonRefs
  class Loader
    class Json
      def call(file)
        JSON.load(file)
      end
    end

    class Yaml
      def call(file)
        YAML.load(file)
      end
    end

    EXTENSIONS = {
      'json' => JsonRefs::Loader::Json,
      'yaml' => JsonRefs::Loader::Yaml,
      'yml' => JsonRefs::Loader::Yaml,
    }.freeze

    def self.handle(filename)
      new.handle(filename)
    end

    def handle(filename)
      f = open(filename)
      @body = f.read
      ext = File.extname(filename)[1..-1]
      ext ||= 'json' if json?(@body)
      ext && EXTENSIONS.include?(ext) ? EXTENSIONS[ext].new.call(@body) : @body
    end

    def json?(file_body)
      JSON.load(file_body)
      true
    rescue JSON::ParserError => e
      false
    end
  end
end
