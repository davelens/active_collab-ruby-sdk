# frozen_string_literal: true

# Provides access to time record endpoints for a specific project.
class ActiveCollab::TimeRecords
  # @param client [ActiveCollab::Client]
  # @param project_id [Integer, String] the project ID
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  # Lists all time records for the project.
  #
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def all(params = {})
    @client
      .get("/projects/#{@project_id}/time-records", params)
  end

  # Creates a new time record for the project.
  #
  # @param params [Hash] time record attributes
  # @return [Hash, String, OpenStruct]
  def create(params = {})
    @client
      .post("/projects/#{@project_id}/time-records", params)
  end
end
