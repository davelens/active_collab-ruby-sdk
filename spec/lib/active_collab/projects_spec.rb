# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveCollab::Projects do
  let(:client) { instance_double(ActiveCollab::Client) }

  subject { described_class.new(client) }

  describe '#list' do
    it 'delegates to client#get with /projects' do
      expect(client).to receive(:get).with('/projects', {})
      subject.list
    end

    it 'passes params to the client' do
      expect(client).to receive(:get).with('/projects', { format: 'json' })
      subject.list(format: 'json')
    end
  end

  describe '#task_lists' do
    it 'returns a TaskLists instance for the given project' do
      result = subject.task_lists(42)
      expect(result).to be_a(ActiveCollab::TaskLists)
    end
  end

  describe '#tasks' do
    it 'returns a Tasks instance for the given project' do
      result = subject.tasks(42)
      expect(result).to be_a(ActiveCollab::Tasks)
    end
  end

  describe '#time_records' do
    it 'returns a TimeRecords instance for the given project' do
      result = subject.time_records(42)
      expect(result).to be_a(ActiveCollab::TimeRecords)
    end
  end
end
