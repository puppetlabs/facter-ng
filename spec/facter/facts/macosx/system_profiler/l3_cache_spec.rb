# frozen_string_literal: true

describe 'Macosx SystemProfilerL3Cache' do
  describe '#call_the_resolver' do
    subject(:fact) { Facter::Macosx::SystemProfilerL3Cache.new }

    let(:value) { '6 MB' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'system_profiler.l3_cache', value: value) }

    before do
      expect(Facter::Resolvers::SystemProfiler).to receive(:resolve).with(:l3_cache).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new)
        .with('system_profiler.l3_cache', value)
        .and_return(expected_resolved_fact)
    end

    it 'returns system_profiler.l3_cache fact' do
      expect(fact.call_the_resolver).to eq(expected_resolved_fact)
    end
  end
end
