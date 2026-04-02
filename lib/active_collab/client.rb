# frozen_string_literal: true

# HTTP client for the ActiveCollab API.
#
# Handles authentication, request construction, and response parsing.
#
# @see https://github.com/activecollab/activecollab-feather-sdk/issues/35
#   Auth flow documentation
class ActiveCollab::Client

  DEFAULTS = {
    username: '',
    password: '',
    client_vendor: '',
    client_name: '',
    account_id: ''
  }.freeze

  HTTP_METHODS = {
    'Get'    => Net::HTTP::Get,
    'Post'   => Net::HTTP::Post,
    'Put'    => Net::HTTP::Put,
    'Delete' => Net::HTTP::Delete
  }.freeze

  APP_URL     = 'https://next-app.activecollab.com'
  API_URL     = 'https://app.activecollab.com'
  AUTH_URL    = 'https://activecollab.com/api/v1'

  # @param options [Hash] client configuration
  # @option options [String] :token pre-existing API token
  # @option options [String] :account_id ActiveCollab account ID
  # @option options [String] :username email address for authentication
  # @option options [String] :password password for authentication
  # @option options [String] :client_vendor vendor name for token issuance
  # @option options [String] :client_name application name for token issuance
  def initialize(options = {})
    @token = options[:token]
    @options = DEFAULTS.merge(options)
  end

  # Performs an HTTP request to the given URI.
  #
  # @param method [String] HTTP method ('Get', 'Post', 'Put', or 'Delete')
  # @param uri [URI] the full request URI
  # @param params [Hash] request parameters
  # @option params [String] :format response format ('hash', 'json', or 'object')
  # @return [Hash, String, OpenStruct] parsed response in the requested format
  # @raise [ActiveCollab::APIError] on 4xx/5xx responses
  def call(method, uri, params = {})
    method = HTTP_METHODS.key?(method) ? method : 'Get'
    data = params.except(:headers, :format)
    format = if %w[hash json object].include?(params[:format])
               params[:format]
             else
               'hash'
             end

    if method == 'Get' && data.present?
      uri.query = [uri.query, data.to_query].compact.join('&')
      request = Net::HTTP::Get.new(uri)
    else
      request = HTTP_METHODS[method].new(uri)
      request.set_form_data(data) unless method == 'Get'
    end

    if @token
      request['X-Angie-AuthApiToken'] = @token
    end

    response = Net::HTTP.start(
      request.uri.hostname,
      request.uri.port,
      use_ssl: request.uri.scheme == "https",
      open_timeout: 30,
      read_timeout: 30
    ) do |http|
      http.request(request)
    end

    handle_response_errors!(response)

    format_method = { 'hash' => :to_hash, 'json' => :to_json_string, 'object' => :to_object }
    ActiveCollab::Response
      .new(response.body)
      .send(format_method[format])
  end

  # Builds a URL for the ActiveCollab web application UI.
  #
  # @param uri [String] path to append (e.g., '/projects/3')
  # @return [URI] the full app URL
  def app_url(uri)
    URI.parse("#{APP_URL}/#{@options[:account_id]}#{uri}")
  end

  # Builds an API endpoint URL for the given path.
  #
  # @param uri [String] API path (e.g., '/projects')
  # @return [URI] the full API URL
  def call_url(uri)
    url = if uri.include?('/external/login')
            "#{AUTH_URL}#{uri}"
          else
            "#{API_URL}/#{@options[:account_id]}/api/v1#{uri}"
          end

    URI.parse(url)
  end

  # Performs a GET request.
  #
  # @param uri [String] API path
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def get(uri, params = {})
    call('Get', call_url(uri), params)
  end

  # Performs a POST request.
  #
  # @param uri [String] API path
  # @param params [Hash] form data parameters
  # @return [Hash, String, OpenStruct]
  def post(uri, params = {})
    call('Post', call_url(uri), params)
  end

  # Performs a PUT request.
  #
  # @param uri [String] API path
  # @param params [Hash] form data parameters
  # @return [Hash, String, OpenStruct]
  def put(uri, params = {})
    call('Put', call_url(uri), params)
  end

  # Performs a DELETE request.
  #
  # @param uri [String] API path
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def delete(uri, params = {})
    call('Delete', call_url(uri), params)
  end

  # Authenticates with username/password and stores the resulting token.
  #
  # @return [String] the issued API token
  # @raise [ActiveCollab::AuthenticationError] if credentials are invalid
  def request_token!
    login_response = ActiveCollab::LoginResponse.new(
      login,
      account_id: @options[:account_id]
    )

    token = issue_token_intent(
      client_vendor: @options[:client_vendor],
      client_name: @options[:client_name],
      intent: login_response.intent
    )

    @token = token.value
    @token
  end

  # Returns the current token wrapped in a Token object.
  #
  # @return [ActiveCollab::Token]
  def token
    ActiveCollab::Token.new(@token)
  end

  # Returns a Projects resource for accessing project endpoints.
  #
  # @return [ActiveCollab::Projects]
  def projects
    ActiveCollab::Projects.new(self)
  end

  # Returns a Users resource for accessing user endpoints.
  #
  # @return [ActiveCollab::Users]
  def users
    ActiveCollab::Users.new(self)
  end

  private

  def handle_response_errors!(response)
    status = response.code.to_i
    return if status < 400

    body = response.body
    message = "API request failed with status #{status}"

    error_class = case status
                  when 401 then ActiveCollab::AuthenticationError
                  when 404 then ActiveCollab::NotFoundError
                  when 429 then ActiveCollab::RateLimitError
                  else ActiveCollab::APIError
                  end

    raise error_class.new(message, status: status, body: body)
  end

  def issue_token_intent(opts = {})
    response = post(
      '/issue-token-intent',
      client_vendor: opts[:client_vendor],
      client_name: opts[:client_name],
      intent: opts[:intent]
    )

    ActiveCollab::Token.new(response['token'])
  end

  def login
    post(
      '/external/login',
      username: @options[:username],
      password: @options[:password]
    )
  end

end
