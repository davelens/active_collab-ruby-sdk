# frozen_string_literal: true

require 'ostruct'

class ActiveCollab::Response
  attr_reader :raw_body

  def initialize(raw_body)
    @raw_body = raw_body
    @raw_body = '{}' if raw_body == '' || raw_body.nil?
  end

  def to_json_string
    @raw_body
  end

  def to_hash
    JSON.parse(@raw_body)
  rescue JSON::ParserError => e
    raise ActiveCollab::ParseError.new(
      "Failed to parse response body as JSON: #{e.message}",
      body: @raw_body
    )
  end

  def to_object
    OpenStruct.new(to_hash)
  end
end
