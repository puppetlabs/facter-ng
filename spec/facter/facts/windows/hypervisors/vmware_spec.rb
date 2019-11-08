# frozen_string_literal: true

describe 'Windows Facterversion' do
  describe '#call_the_resolver' do
    context 'when is not VMware hypervisor' do
      it 'returns nil' do
        expected_fact = double(Facter::ResolvedFact, name: 'hypervisors.vmware', value: nil)
        allow(Facter::Resolvers::CpuidSource).to receive(:resolve).with(:vendor).and_return('value')
        allow(Facter::Resolvers::DMIBios).to receive(:resolve).with(:manufacturer).and_return('value')
        allow(Facter::ResolvedFact).to receive(:new).with('hypervisors.vmware', nil).and_return(expected_fact)

        fact = Facter::Windows::HypervisorsVmware.new
        expect(fact.call_the_resolver).to eq(expected_fact)
      end
    end

    context 'when is VMware hypervisor and CpuidSource resolver returns the required output' do
      it 'returns a fact' do
        expected_fact = double(Facter::ResolvedFact, name: 'hypervisors.vmware', value: {})
        allow(Facter::Resolvers::CpuidSource).to receive(:resolve).with(:vendor).and_return('VMwareVMware')
        allow(Facter::ResolvedFact).to receive(:new).with('hypervisors.vmware', {}).and_return(expected_fact)

        fact = Facter::Windows::HypervisorsVmware.new
        expect(fact.call_the_resolver).to eq(expected_fact)
      end
    end

    context 'when is VMware hypervisor and DmiBios resolver returns the required output' do
      it 'returns a fact' do
        expected_fact = double(Facter::ResolvedFact, name: 'hypervisors.vmware', value: {})
        allow(Facter::Resolvers::CpuidSource).to receive(:resolve).with(:vendor).and_return('value')
        allow(Facter::Resolvers::DMIBios).to receive(:resolve).with(:manufacturer).and_return('VMware, Inc.')
        allow(Facter::ResolvedFact).to receive(:new).with('hypervisors.vmware', {}).and_return(expected_fact)

        fact = Facter::Windows::HypervisorsVmware.new
        expect(fact.call_the_resolver).to eq(expected_fact)
      end
    end
  end
end
