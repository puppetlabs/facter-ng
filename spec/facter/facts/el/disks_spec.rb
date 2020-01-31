describe 'El disks' do
  let(:disk) {
    {
      disks: {
        sda: {
          model: "Virtual disk",
          size: "20.00 GiB",
          size_bytes: 21474836480,
          vendor: "VMware"
        }
      }
    }
  }

  subject(:fact) { Facter::El::Disks.new }



  context '#call_the_resolver' do
    before(:each) do
      allow(Facter::Resolvers::Linux::Disk).to receive(:resolve).with(:disks).and_return(disk)
    end

    it 'calls Facter::Resolvers::Linux::Disk' do
      expect(Facter::Resolvers::Linux::Disk).to receive(:resolve).with(:disks)
      fact.call_the_resolver
    end

    it 'returns resolved fact with name disk and value' do
      expect(fact.call_the_resolver)
        .to be_an_instance_of(Facter::ResolvedFact)
        .and have_attributes(name: 'disks', value: disk)
    end
  end
end