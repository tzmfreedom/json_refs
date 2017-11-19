require "spec_helper"

RSpec.describe JsonRefs do
  it "has a version number" do
    expect(JsonRefs::VERSION).not_to be nil
  end

  let(:input) {
    {
      'integer' => 123,
      'string' => 'abc',
      'array' => [1, '2', true],
      'hash' => {
        'string' => 'aaa',
        'integer' => 111,
        'boolean' => true,
      },
      'refs_integer' => {
        '$ref' => '#/integer'
      },
      'refs_string' => {
        '$ref' => '#/string'
      },
      'refs_array' => {
        '$ref' => '#/array'
      },
      'refs_hash' => {
        '$ref' => '#/hash'
      },
      'nest_hash' => {
        'a' => {
          'b' => {
            'c' => {
              '$ref' => '#/hash'
            }
          }
        }
      },
      'local_file_path' => {
        '$ref' => File.expand_path('../fixtures/referenced.json', __FILE__)
      },
      'remote_file_path' => {
        '$ref' => 'http://httpbin.org/user-agent'
      },
      'yml' => {
        '$ref' => File.expand_path('../fixtures/referenced.yaml', __FILE__)
      },
      'yaml' => {
        '$ref' => File.expand_path('../fixtures/referenced.yml', __FILE__)
      }
    }
  }

  let(:expected) {
    {
      'integer' => 123,
      'string' => 'abc',
      'array' => [1, '2', true],
      'hash' => {
        'string' => 'aaa',
        'integer' => 111,
        'boolean' => true,
      },
      'refs_integer' => 123,
      'refs_string' => 'abc',
      'refs_array' => [1, '2', true],
      'refs_hash' => {
        'string' => 'aaa',
        'integer' => 111,
        'boolean' => true,
      },
      'nest_hash' => {
        'a' => {
          'b' => {
            'c' => {
              'string' => 'aaa',
              'integer' => 111,
              'boolean' => true,
            }
          }
        }
      },
      'local_file_path' => {
        'referenced' => {
          'string' => 'aaa',
          'integer' => 123,
          'boolean' => true
        }
      },
      'remote_file_path' => {
        'user-agent' => 'Ruby'
      },
      'yml' => {
        'yaml_attr' => 'yaml_value'
      },
      'yaml' => {
        'yaml_attr' => 'yaml_value'
      }
    }
  }

  it "dereference JSON reference" do
    result = JsonRefs.(input)
    expect(result).to eq(expected)
  end
end
