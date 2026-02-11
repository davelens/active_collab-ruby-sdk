# frozen_string_literal: true

class ActiveCollab::Tasks
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  # Works:
  # curl -i -H "X-Angie-AuthApiToken: <TOKEN>" \
  #   https://app.activecollab.com/167099/api/v1/projects/3/tasks
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

  # Works:
  # curl -i -H "X-Angie-AuthApiToken: <TOKEN>" \
  #   https://app.activecollab.com/167099/api/v1/projects/3/tasks
  def active(params = {})
    @client
      .get("/projects/#{@project_id}/tasks", params)
  end

  # These include completed tasks.
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

  def get(id, params = {})
    @client
      .get("/projects/#{@project_id}/tasks/#{id}", params)
  end

  def time_records(id, params = {})
    @client
      .get("/projects/#{@project_id}/tasks/#{id}/time-records", params)
  end

  def update(id, params = {})
    @client
      .put("/projects/#{@project_id}/tasks/#{id}", params)
  end
end
