class ActiveCollab::Projects
  def initialize(client)
    @client = client
  end

  def list(params = {})
    @client.get('/projects', params)
  end

  def task_lists(project_id)
    ActiveCollab::TaskLists.new(@client, project_id)
  end

  def tasks(project_id)
    ActiveCollab::Tasks.new(@client, project_id)
  end

  def time_records(project_id)
    ActiveCollab::TimeRecords.new(@client, project_id)
  end

end
