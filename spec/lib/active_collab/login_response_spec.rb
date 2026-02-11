require 'spec_helper'

RSpec.describe ActiveCollab::LoginResponse do
  let(:account_id) { '1337' }
  let(:values) do
    {
      'accounts' => [
        { 'name' => '999', 'url' => 'https://app.activecollab.com/999' },
        { 'name' => '1337', 'url' => 'https://app.activecollab.com/1337' }
      ],
      'user' => {
        'intent' => 'intent-token-abc'
      }
    }
  end

  subject { described_class.new(values, account_id: account_id) }

  describe '#accounts' do
    it 'returns the accounts array from the response' do
      expect(subject.accounts).to eq(values['accounts'])
    end

    it 'memoizes the result' do
      expect(subject.accounts).to be(subject.accounts)
    end
  end

  describe '#account_info' do
    it 'returns the account matching the given account_id' do
      expect(subject.account_info).to eq(
        { 'name' => '1337', 'url' => 'https://app.activecollab.com/1337' }
      )
    end

    it 'returns nil when no account matches' do
      response = described_class.new(values, account_id: 'nonexistent')
      expect(response.account_info).to be_nil
    end

    it 'memoizes the result' do
      expect(subject.account_info).to be(subject.account_info)
    end
  end

  describe '#call_url' do
    it 'returns the URL of the matching account' do
      expect(subject.call_url).to eq('https://app.activecollab.com/1337')
    end
  end

  describe '#intent' do
    it 'returns the user intent from the response' do
      expect(subject.intent).to eq('intent-token-abc')
    end

    it 'returns nil when user intent is missing' do
      response = described_class.new({}, account_id: account_id)
      expect(response.intent).to be_nil
    end
  end
end
