# frozen_string_literal: true

describe 'Fedora Path' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'path', value: '/Users/User/.rvm/gems/ruby-2.4.6/bin:/Users/User/.rvm/gems/ruby-2.4.6@global/bin:/Users/User/.rvm/rubies/ruby-2.4.6/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/puppetlabs/bin:/Users/User/.rvm/bin')
      allow(Facter::Resolvers::Path).to receive(:resolve).with(:path).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('path', 'value').and_return(expected_fact)

      fact = Facter::Fedora::Path.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
