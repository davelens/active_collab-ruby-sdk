class ActiveCollab::TimeRecords
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  def all
    @client
      .get("/projects/#{@project_id}/time-records")
      .dig('time_records')
  end

  def push(id, values = {})
    @client.post("/projects/#{id}/time-records", values)
  end
end
