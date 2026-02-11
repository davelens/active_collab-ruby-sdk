# frozen_string_literal: true

class ActiveCollab::LoginResponse
  def initialize(values, account_id: nil)
    @values = values
    @account_id = account_id
  end

  def accounts
    @accounts ||= @values['accounts']
  end

  def account_info
    return @account unless @account.nil?

    @account = accounts.detect do |account|
      account['name'].to_s == @account_id.to_s
    end

    @account
  end

  def call_url
    account_info['url']
  end

  def intent
    @values.dig('user', 'intent')
  end
end
