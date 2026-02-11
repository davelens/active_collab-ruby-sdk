# frozen_string_literal: true

# Provides access to user-related API endpoints.
class ActiveCollab::Users
  # @param client [ActiveCollab::Client]
  def initialize(client)
    @client = client
  end

  # Lists all users.
  #
  # @return [Hash, String, OpenStruct]
  def all
    @client.get('/users')
  end
end
