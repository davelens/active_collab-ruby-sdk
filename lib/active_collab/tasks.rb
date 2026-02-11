# frozen_string_literal: true

# Provides access to task-related API endpoints for a specific project.
class ActiveCollab::Tasks
  # @param client [ActiveCollab::Client]
  # @param project_id [Integer, String] the project ID
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  # Returns all tasks (active + archived), sorted by created_on descending.
  #
  # @param params [Hash] query parameters
  # @option params [String] 'format' response format ('hash' or 'json')
  # @return [Hash, String] a hash with a 'tasks' key, or JSON string
  def all(params = {})
    temp_params = params.merge('format' => 'hash')
    all_tasks = [active(temp_params)['tasks'] + archived(temp_params)['tasks']]
    result = {
      'tasks' => all_tasks
        .flatten
        .sort_by { |t| -t['created_on'] } || []
    }

    return JSON.generate(result) if params['format'] == 'json'
    result
  end

  # Returns active (non-archived) tasks for the project.
  #
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def active(params = {})
    @client
      .get("/projects/#{@project_id}/tasks", params)
  end

  # Returns archived tasks for the project.
  #
  # Auto-paginates through all pages unless a specific page is requested.
  #
  # @param params [Hash] query parameters
  # @option params [Integer] 'page' specific page to fetch (disables auto-pagination)
  # @option params [String] 'format' response format ('hash' or 'json')
  # @return [Hash, String] a hash with a 'tasks' key, or JSON string
  def archived(params = {})
    page = params['page'] || 1
    all_tasks = []

    loop do
      response = @client
        .get("/projects/#{@project_id}/tasks/archive", params.merge('page' => page))
      tasks = response || []
      all_tasks += tasks
      break if tasks.empty? || params.key?('page')
      page += 1
    end

    result = { 'tasks' => all_tasks.flatten.sort_by { |t| -t['created_on'] } }
    return JSON.generate(result) if params['format'] == 'json'
    result
  end

  # Fetches a single task by ID.
  #
  # @param id [Integer, String] the task ID
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def find(id, params = {})
    @client
      .get("/projects/#{@project_id}/tasks/#{id}", params)
  end

  # Fetches time records for a specific task.
  #
  # @param id [Integer, String] the task ID
  # @param params [Hash] query parameters
  # @return [Hash, String, OpenStruct]
  def time_records(id, params = {})
    @client
      .get("/projects/#{@project_id}/tasks/#{id}/time-records", params)
  end

  # Updates a task.
  #
  # @param id [Integer, String] the task ID
  # @param params [Hash] fields to update
  # @return [Hash, String, OpenStruct]
  def update(id, params = {})
    @client
      .put("/projects/#{@project_id}/tasks/#{id}", params)
  end
end
