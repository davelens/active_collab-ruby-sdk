# Info about the, quite undocumented!, necessary auth calls:
# https://github.com/activecollab/activecollab-feather-sdk/issues/35
class ActiveCollab::Client

  def initialize(options = {})
    @token = options[:token]
    @options = options.reverse_merge!(
      username: '',
      password: '',
      client_vendor: '',
      client_name: '',
      account_id: ''
    )
  end

  def call(method, uri, params = {})
    method = %w[Post Get Put].include?(method) ? method : 'Get'
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
      request = Object.const_get("Net::HTTP::#{method}").new(uri)
      request.set_form_data(data) unless method == 'Get'
    end

    if @token
      request['X-Angie-AuthApiToken'] = @token
    end

    response = Net::HTTP.start(
      request.uri.hostname,
      request.uri.port,
      { use_ssl: request.uri.scheme == "https" }
    ) do |http|
      http.request(request)
    end

    return ActiveCollab::Response
      .new(response.body)
      .send(:"to_#{format}")
  end

  def app_url(uri)
    URI.parse("https://next-app.activecollab.com/#{@options[:account_id]}#{uri}")
  end

  def call_url(uri)
    url = if uri.include?('/external/login')
            "https://activecollab.com/api/v1#{uri}"
          else
            "https://app.activecollab.com/#{@options[:account_id]}/api/v1#{uri}"
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

  ############################################################################

  def projects
    ActiveCollab::Projects.new(self)
  end

  ############################################################################

  private

  def issue_token_intent(opts = {})
    response = post(
      '/issue-token-intent',
      client_vendor: opts[:client_vendor],
      client_name: opts[:client_name],
      intent: opts[:intent]
    )

    ActiveCollab::Token.new(response.dig('token'))
  end

  def login
    post(
      '/external/login',
      username: @options[:username],
      password: @options[:password]
    )
  end

end
