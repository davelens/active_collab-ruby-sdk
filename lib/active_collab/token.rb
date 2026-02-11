# frozen_string_literal: true

# Represents an ActiveCollab API authentication token.
class ActiveCollab::Token
  # @return [String] the raw token string
  attr_reader :value

  # @param value [String] the API token
  def initialize(value)
    @value = value
  end

  # Returns the token as an HTTP authentication header hash.
  #
  # @return [Hash{Symbol => String}]
  def auth_header
    {
      'X-Angie-AuthApiToken': @value
    }
  end
end
