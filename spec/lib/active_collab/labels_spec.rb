# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveCollab::Labels do
  let(:client) { instance_double(ActiveCollab::Client) }

  subject { described_class.new(client) }

  describe '#all' do
    it 'fetches all task labels' do
      expect(client).to receive(:get).with('/labels/task-labels', {})
      subject.all('task-labels')
    end

    it 'fetches all project labels' do
      expect(client).to receive(:get).with('/labels/project-labels', {})
      subject.all('project-labels')
    end

    it 'passes params to the client' do
      expect(client).to receive(:get).with('/labels/task-labels', { format: 'json' })
      subject.all('task-labels', format: 'json')
    end

    it 'raises ArgumentError for invalid type' do
      expect { subject.all('invalid-type') }.to raise_error(
        ArgumentError, /must be one of: task-labels, project-labels/
      )
    end
  end

  describe '#find' do
    it 'fetches a single label by id' do
      expect(client).to receive(:get).with('/labels/5', {})
      subject.find(5)
    end

    it 'passes params to the client' do
      expect(client).to receive(:get).with('/labels/5', { format: 'json' })
      subject.find(5, format: 'json')
    end
  end

  describe '#create' do
    it 'creates a label via POST' do
      expect(client).to receive(:post).with('/labels', { type: 'TaskLabel', name: 'Urgent' })
      subject.create(type: 'TaskLabel', name: 'Urgent')
    end
  end

  describe '#update' do
    it 'updates a label via PUT' do
      expect(client).to receive(:put).with('/labels/5', { name: 'Critical', color: '#FF0000' })
      subject.update(5, name: 'Critical', color: '#FF0000')
    end
  end

  describe '#delete' do
    it 'deletes a label via DELETE' do
      expect(client).to receive(:delete).with('/labels/5', {})
      subject.delete(5)
    end
  end

  describe '#reorder' do
    it 'reorders labels via PUT with an array of IDs' do
      expect(client).to receive(:put).with('/labels/reorder', [1, 16, 2, 4])
      subject.reorder([1, 16, 2, 4])
    end
  end
end
