class ActiveCollab::TaskLists
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  def all
    @client
      .get("/projects/#{@project_id}/task-lists")
  end
end
