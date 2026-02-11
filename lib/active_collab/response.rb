# frozen_string_literal: true

require 'ostruct'

# Wraps a raw HTTP response body and provides format conversion.
class ActiveCollab::Response
  # @return [String] the raw response body
  attr_reader :raw_body

  # @param raw_body [String, nil] the raw HTTP response body
  def initialize(raw_body)
    @raw_body = raw_body
    @raw_body = '{}' if raw_body == '' || raw_body.nil?
  end

  # Returns the raw response body as a JSON string.
  #
  # @return [String]
  def to_json_string
    @raw_body
  end

  # Parses the response body as a Ruby Hash.
  #
  # @return [Hash]
  # @raise [ActiveCollab::ParseError] if the body is not valid JSON
  def to_hash
    JSON.parse(@raw_body)
  rescue JSON::ParserError => e
    raise ActiveCollab::ParseError.new(
      "Failed to parse response body as JSON: #{e.message}",
      body: @raw_body
    )
  end

  # Parses the response body into an OpenStruct.
  #
  # @return [OpenStruct]
  # @raise [ActiveCollab::ParseError] if the body is not valid JSON
  def to_object
    OpenStruct.new(to_hash)
  end
end
