# frozen_string_literal: true

describe 'Macosx IsVirtual' do
  context '#call_the_resolver on virtual machines' do
    let(:value) { 'true' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'is_virtual', value: value) }
    subject(:fact) { Facter::Macosx::IsVirtual.new }

    #  it 'returns true for virtual machines' do
    #    allow(Facter::Resolvers::SystemProfiler).to receive(:`)
    #      .with('system_profiler SPHardwareDataType SPSoftwareDataType SPEthernetDataType')
    #      .and_return(load_fixture('system_profiler_VM').read)
    #
    #    expect(fact.call_the_resolver).to eq(expected_resolved_fact)
    #  end
    # end
    #
    # context '#call_the_resolver on physical machines' do
    #  let(:value) { 'false' }
    #  let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'is_virtual', value: value) }
    #  subject(:fact) { Facter::Macosx::IsVirtual.new }
    #
    #  it 'returns false for physical machines' do
    #    allow(Facter::Resolvers::SystemProfiler).to receive(:`)
    #      .with('system_profiler SPHardwareDataType SPSoftwareDataType SPEthernetDataType')
    #      .and_return(load_fixture('system_profiler').read)
    #
    #    expect(fact.call_the_resolver).to eq(expected_resolved_fact)
    #  end
  end
end
