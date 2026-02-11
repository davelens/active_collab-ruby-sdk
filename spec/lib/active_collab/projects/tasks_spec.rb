# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveCollab::Tasks do
  let(:client) { instance_double(ActiveCollab::Client) }
  let(:project_id) { 42 }

  subject { described_class.new(client, project_id) }

  describe '#active' do
    it 'fetches active tasks for the project' do
      expect(client).to receive(:get).with("/projects/#{project_id}/tasks", {})
      subject.active
    end

    it 'passes params to the client' do
      expect(client).to receive(:get).with("/projects/#{project_id}/tasks", { format: 'json' })
      subject.active(format: 'json')
    end
  end

  describe '#archived' do
    it 'fetches archived tasks and paginates until empty' do
      page1 = [{ 'id' => 1, 'created_on' => 100 }]
      page2 = []

      expect(client).to receive(:get)
        .with("/projects/#{project_id}/tasks/archive", { page: 1 })
        .and_return(page1)
      expect(client).to receive(:get)
        .with("/projects/#{project_id}/tasks/archive", { page: 2 })
        .and_return(page2)

      result = subject.archived
      expect(result).to eq({ 'tasks' => [{ 'id' => 1, 'created_on' => 100 }] })
    end

    it 'does not paginate when a page param is explicitly given' do
      page_data = [{ 'id' => 1, 'created_on' => 100 }]

      expect(client).to receive(:get)
        .with("/projects/#{project_id}/tasks/archive", { 'page' => 2, page: 2 })
        .and_return(page_data)

      result = subject.archived('page' => 2)
      expect(result).to eq({ 'tasks' => [{ 'id' => 1, 'created_on' => 100 }] })
    end

    it 'returns JSON when format is json' do
      expect(client).to receive(:get).and_return([])

      result = subject.archived('format' => 'json')
      expect(result).to be_a(String)
      expect(JSON.parse(result)).to eq({ 'tasks' => [] })
    end

    it 'sorts tasks by created_on descending' do
      tasks = [
        { 'id' => 1, 'created_on' => 100 },
        { 'id' => 2, 'created_on' => 300 },
        { 'id' => 3, 'created_on' => 200 }
      ]
      expect(client).to receive(:get).and_return(tasks)
      expect(client).to receive(:get).and_return([])

      result = subject.archived
      expect(result['tasks'].map { |t| t['id'] }).to eq([2, 3, 1])
    end
  end

  describe '#all' do
    before do
      allow(client).to receive(:get)
        .with("/projects/#{project_id}/tasks", hash_including('format' => 'hash'))
        .and_return({ 'tasks' => [{ 'id' => 1, 'created_on' => 200 }] })

      allow(client).to receive(:get)
        .with("/projects/#{project_id}/tasks/archive", hash_including('format' => 'hash'))
        .and_return([{ 'id' => 2, 'created_on' => 100 }])

      # Second page returns empty to stop pagination
      allow(client).to receive(:get)
        .with("/projects/#{project_id}/tasks/archive", hash_including(page: 2))
        .and_return([])
    end

    it 'combines active and archived tasks sorted by created_on descending' do
      result = subject.all
      expect(result['tasks'].map { |t| t['id'] }).to eq([1, 2])
    end

    it 'returns JSON when format is json' do
      result = subject.all('format' => 'json')
      expect(result).to be_a(String)
      parsed = JSON.parse(result)
      expect(parsed).to have_key('tasks')
    end
  end

  describe '#get' do
    it 'fetches a single task by id' do
      expect(client).to receive(:get).with("/projects/#{project_id}/tasks/7", {})
      subject.get(7)
    end

    it 'passes params to the client' do
      expect(client).to receive(:get).with("/projects/#{project_id}/tasks/7", { format: 'json' })
      subject.get(7, format: 'json')
    end
  end

  describe '#time_records' do
    it 'fetches time records for a specific task' do
      expect(client).to receive(:get).with("/projects/#{project_id}/tasks/7/time-records", {})
      subject.time_records(7)
    end
  end

  describe '#update' do
    it 'sends a PUT request to update the task' do
      expect(client).to receive(:put).with("/projects/#{project_id}/tasks/7", { name: 'Updated' })
      subject.update(7, name: 'Updated')
    end
  end
end
