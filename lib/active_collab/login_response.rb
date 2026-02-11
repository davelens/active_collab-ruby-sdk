# frozen_string_literal: true

# Wraps the response from the ActiveCollab login endpoint.
#
# Used internally by {Client#request_token!} to extract the intent
# token needed for API token issuance.
class ActiveCollab::LoginResponse
  # @param values [Hash] parsed login response body
  # @param account_id [String, nil] the account ID to match
  def initialize(values, account_id: nil)
    @values = values
    @account_id = account_id
  end

  # Returns the list of accounts from the login response.
  #
  # @return [Array<Hash>]
  def accounts
    @accounts ||= @values['accounts']
  end

  # Returns the account matching the configured account ID.
  #
  # @return [Hash, nil] the matching account, or nil if not found
  def account_info
    return @account unless @account.nil?

    @account = accounts.detect do |account|
      account['name'].to_s == @account_id.to_s
    end

    @account
  end

  # Returns the API URL for the matching account.
  #
  # @return [String]
  def call_url
    account_info['url']
  end

  # Returns the user intent token from the login response.
  #
  # @return [String, nil]
  def intent
    @values.dig('user', 'intent')
  end
end
