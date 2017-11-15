require "spec_helper"

RSpec.describe JsonRefs do
  it "has a version number" do
    expect(JsonRefs::VERSION).not_to be nil
  end

  def desymbolize(hash)
    hash.inject({}) do |h, (k, v)|
      h[k.to_s] = v
      h
    end
  end

  it "dereference JSON reference" do
    result = JsonRefs.(desymbolize({
      integer: 123,
      string: 'abc',
      array: [1, '2', true],
      hash: {
        string: 'aaa',
        integer: 111,
        boolean: true,
      },
      refs_integer: {
        '$ref' => '#/integer'
      },
      refs_string: {
        '$ref' => '#/string'
      },
      refs_array: {
        '$ref' => '#/array'
      },
      refs_hash: {
        '$ref' => '#/hash'
      },
      nest_hash: {
        a: {
          b: {
            c: {
              '$ref' => '#/hash'
            }
          }
        }
      }
    }))
    expect(result).to eq(desymbolize({
      integer: 123,
      string: 'abc',
      array: [1, '2', true],
      hash: {
        string: 'aaa',
        integer: 111,
        boolean: true,
      },
      refs_integer: 123,
      refs_string: 'abc',
      refs_array: [1, '2', true],
      refs_hash: {
        string: 'aaa',
        integer: 111,
        boolean: true,
      },
      nest_hash: {
        a: {
          b: {
            c: {
              string: 'aaa',
              integer: 111,
              boolean: true,
            }
          }
        }
      }
    }))
  end
end
