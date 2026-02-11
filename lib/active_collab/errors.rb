# frozen_string_literal: true

module ActiveCollab
  # Base error class for all ActiveCollab errors.
  class Error < StandardError; end

  # Raised when the API returns an error HTTP response (4xx/5xx).
  class APIError < Error
    attr_reader :status, :body

    def initialize(message = nil, status: nil, body: nil)
      @status = status
      @body = body
      super(message || "API request failed with status #{status}")
    end
  end

  # Raised on 401 Unauthorized responses.
  class AuthenticationError < APIError; end

  # Raised on 404 Not Found responses.
  class NotFoundError < APIError; end

  # Raised on 429 Too Many Requests responses.
  class RateLimitError < APIError; end

  # Raised when a response body cannot be parsed as JSON.
  class ParseError < Error
    attr_reader :body

    def initialize(message = nil, body: nil)
      @body = body
      super(message || 'Failed to parse response body as JSON')
    end
  end
end
