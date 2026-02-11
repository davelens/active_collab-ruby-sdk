# frozen_string_literal: true

# Info about the, quite undocumented!, necessary auth calls:
# https://github.com/activecollab/activecollab-feather-sdk/issues/35
class ActiveCollab::Client

  DEFAULTS = {
    username: '',
    password: '',
    client_vendor: '',
    client_name: '',
    account_id: ''
  }.freeze

  HTTP_METHODS = {
    'Get'  => Net::HTTP::Get,
    'Post' => Net::HTTP::Post,
    'Put'  => Net::HTTP::Put
  }.freeze

  APP_URL     = 'https://next-app.activecollab.com'
  API_URL     = 'https://app.activecollab.com'
  AUTH_URL    = 'https://activecollab.com/api/v1'

  def initialize(options = {})
    @token = options[:token]
    @options = DEFAULTS.merge(options)
  end

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

  def app_url(uri)
    URI.parse("#{APP_URL}/#{@options[:account_id]}#{uri}")
  end

  def call_url(uri)
    url = if uri.include?('/external/login')
            "#{AUTH_URL}#{uri}"
          else
            "#{API_URL}/#{@options[:account_id]}/api/v1#{uri}"
          end

    URI.parse(url)
  end

  def get(uri, params = {})
    call('Get', call_url(uri), params)
  end

  def post(uri, params = {})
    call('Post', call_url(uri), params)
  end

  def put(uri, params = {})
    call('Put', call_url(uri), params)
  end

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

  def token
    ActiveCollab::Token.new(@token)
  end

  def projects
    ActiveCollab::Projects.new(self)
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
