# frozen_string_literal: true

# Provides access to task list endpoints for a specific project.
class ActiveCollab::TaskLists
  # @param client [ActiveCollab::Client]
  # @param project_id [Integer, String] the project ID
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  # Lists all task lists for the project.
  #
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def all(params = {})
    @client
      .get("/projects/#{@project_id}/task-lists", params)
  end
end
