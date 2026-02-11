# frozen_string_literal: true

# Provides access to project-related API endpoints.
class ActiveCollab::Projects
  # @param client [ActiveCollab::Client]
  def initialize(client)
    @client = client
  end

  # Lists all projects.
  #
  # @param params [Hash] query parameters
  # @option params [String] :format response format ('hash', 'json', or 'object')
  # @return [Hash, String, OpenStruct]
  def all(params = {})
    @client.get('/projects', params)
  end

  # Returns a TaskLists resource scoped to the given project.
  #
  # @param project_id [Integer, String] the project ID
  # @return [ActiveCollab::TaskLists]
  def task_lists(project_id)
    ActiveCollab::TaskLists.new(@client, project_id)
  end

  # Returns a Tasks resource scoped to the given project.
  #
  # @param project_id [Integer, String] the project ID
  # @return [ActiveCollab::Tasks]
  def tasks(project_id)
    ActiveCollab::Tasks.new(@client, project_id)
  end

  # Returns a TimeRecords resource scoped to the given project.
  #
  # @param project_id [Integer, String] the project ID
  # @return [ActiveCollab::TimeRecords]
  def time_records(project_id)
    ActiveCollab::TimeRecords.new(@client, project_id)
  end
end
