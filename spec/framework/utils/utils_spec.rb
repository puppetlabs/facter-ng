# frozen_string_literal: true

describe 'Utils' do
  let(:hash_to_change) { { this: { is: [{ 1 => 'test' }] } } }
  let(:result) { { 'this' => { 'is' => [{ '1' => 'test' }] } } }
  let(:subject) { Facter::Utils }

  context '#deep_stringify_keys' do
    it 'stringify keys in hash' do
      expect(subject.deep_stringify_keys(hash_to_change)).to eql(result)
    end
  end
end
