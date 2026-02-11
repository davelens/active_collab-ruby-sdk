# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveCollab::TaskLists do
  let(:client) { instance_double(ActiveCollab::Client) }
  let(:project_id) { 42 }

  subject { described_class.new(client, project_id) }

  describe '#all' do
    it 'fetches all task lists for the project' do
      expect(client).to receive(:get).with("/projects/#{project_id}/task-lists", {})
      subject.all
    end

    it 'passes params to the client' do
      expect(client).to receive(:get).with("/projects/#{project_id}/task-lists", { format: 'json' })
      subject.all(format: 'json')
    end
  end
end
