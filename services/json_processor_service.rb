require 'json-schema'

class JsonProcessorService
  attr_writer :input
  attr_reader :errors, :paste

  def execute
    validate_json
    return if @errors
    parse_json
    build_paste
  end

  private

  def validate_json
    @errors = !JSON::Validator.validate('config/paste_schema.json', @input)
  end

  def parse_json
    params = JSON.parse(@input)
    @name = params.delete('name')
    @content = params.delete('content')
  end

  def build_paste
    @paste = Paste.new(:name => @name, :content => @content)
  end
end
