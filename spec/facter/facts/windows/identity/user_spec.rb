# frozen_string_literal: true

describe 'Windows IdentityUser' do
  context '#call_the_resolver' do
    let(:value) { 'User\Administrator' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'identity.user', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'id', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::IdentityUser.new }

    before do
      expect(Facter::Resolvers::Identity).to receive(:resolve).with(:user).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('identity.user', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('id', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns user name' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
