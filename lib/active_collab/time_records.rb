# frozen_string_literal: true

class ActiveCollab::TimeRecords
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  def all(params = {})
    @client
      .get("/projects/#{@project_id}/time-records", params)
  end

  def create(params = {})
    @client
      .post("/projects/#{@project_id}/time-records", params)
  end
end
