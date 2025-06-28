class ActiveCollab::TimeRecords
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  def all(params = {})
    @client
      .get("/projects/#{@project_id}/time-records", params)
  end

  def push(params = {})
    @client
      .post("/projects/#{@project_id}/time-records", params)
  end
end
