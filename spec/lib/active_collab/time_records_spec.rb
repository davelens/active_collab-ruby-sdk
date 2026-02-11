# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveCollab::TimeRecords do
  let(:client) { instance_double(ActiveCollab::Client) }
  let(:project_id) { 42 }

  subject { described_class.new(client, project_id) }

  describe '#all' do
    it 'fetches all time records for the project' do
      expect(client).to receive(:get).with("/projects/#{project_id}/time-records", {})
      subject.all
    end

    it 'passes params to the client' do
      expect(client).to receive(:get).with("/projects/#{project_id}/time-records", { format: 'json' })
      subject.all(format: 'json')
    end
  end

  describe '#push' do
    it 'creates a time record via POST' do
      params = { value: 1.5, user_id: 10, job_type_id: 1 }
      expect(client).to receive(:post).with("/projects/#{project_id}/time-records", params)
      subject.push(params)
    end
  end
end
