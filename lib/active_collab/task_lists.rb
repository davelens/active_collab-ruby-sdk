# frozen_string_literal: true

class ActiveCollab::TaskLists
  def initialize(client, project_id)
    @client = client
    @project_id = project_id
  end

  def all(params = {})
    @client
      .get("/projects/#{@project_id}/task-lists", params)
  end
end
