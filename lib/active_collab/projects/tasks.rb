class ActiveCollab::Tasks
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  # Works:
  # curl -i -H "X-Angie-AuthApiToken: <TOKEN>" \
  #   https://app.activecollab.com/167099/api/v1/projects/3/tasks
  def all(params = {})
    @client
      .get("/projects/#{@project_id}/tasks", params)
  end

  # These include completed tasks.
  def archive(params = {})
    @client
      .get("/projects/#{@project_id}/tasks/archive", params)
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
