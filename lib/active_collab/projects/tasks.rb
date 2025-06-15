class ActiveCollab::Tasks
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  # Works:
  # curl -i -H "X-Angie-AuthApiToken: <TOKEN>" \
  #   https://app.activecollab.com/167099/api/v1/projects/3/tasks
  def all
    @client
      .get("/projects/#{@project_id}/tasks")
      .dig('tasks')
  end

  def get(id)
    @client
      .get("/projects/#{@project_id}/tasks/#{id}")
  end

  def time_records(id)
    @client
      .get("/projects/#{@project_id}/tasks/#{id}/time-records")
      .dig('time_records')
  end

  def update(id, params)
    @client
      .put("/projects/#{@project_id}/tasks/#{id}", params)
  end
end
