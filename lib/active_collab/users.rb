# frozen_string_literal: true

class ActiveCollab::Users
  def initialize(client)
    @client = client
  end

  def all
    @client.get('/users')
  end
end
