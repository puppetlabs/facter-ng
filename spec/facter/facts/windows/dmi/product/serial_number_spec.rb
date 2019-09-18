# frozen_string_literal: true

describe 'Windows DmiProductSerialNumber' do
  context '#call_the_resolver' do
    it 'returns a fact' do
<<<<<<< HEAD
      expected_fact = double(Facter::Fact, name: 'dmi.product.serial_number', value: 'value')
      allow(DMIBiosResolver).to receive(:resolve).with(:serial_number).and_return('value')
      allow(Facter::Fact).to receive(:new).with('dmi.product.serial_number', 'value').and_return(expected_fact)
=======
      expected_fact = double(Facter::ResolvedFact, name: 'dmi.product.serial_number', value: 'value')
      allow(DMIBiosResolver).to receive(:resolve).with(:serial_number).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('dmi.product.serial_number', 'value').and_return(expected_fact)
>>>>>>> fb08b0b67d14e86d033b885bcecd3c84a3769691

      fact = Facter::Windows::DmiProductSerialNumber.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
