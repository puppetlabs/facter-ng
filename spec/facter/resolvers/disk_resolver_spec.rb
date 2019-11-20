# frozen_string_literal: true

describe 'DiskResolver' do
  describe '#resolve' do
    context 'when sr0_model exists' do
      let(:sr0_model) { 'VMware IDE CDR00' }
      it 'returns sr0_model' do
        allow(File).to receive(:read).with('/sys/block/sr0/device/model').and_return(sr0_model)
        result = Facter::Resolvers::Linux::Disk.resolve(:sr0_model)

        expect(result).to eq(sr0_model)
      end
    end
    context 'when sr0_size exists' do
      let(:sr0_size) { 1073741312 * 1024 }
      it 'returns sr0_size' do
        allow(File).to receive(:read).with('/sys/block/sr0/size').and_return(sr0_size)
        result = Facter::Resolvers::Linux::Disk.resolve(:sr0_size)

        expect(result).to eq(sr0_size)
      end
    end
    context 'when sr0_vendor exists' do
      let(:sr0_vendor) { 'NECVMWar' }
      it 'returns sr0_vendor' do
        allow(File).to receive(:read).with('/sys/block/sr0/device/vendor').and_return(sr0_vendor)
        result = Facter::Resolvers::Linux::Disk.resolve(:sr0_vendor)

        expect(result).to eq(sr0_vendor)
      end
    end
    context 'when sda_model exists' do
      let(:sda_model) { 'Virtual disk' }
      it 'returns sda_model' do
        allow(File).to receive(:read).with('/sys/block/sda/device/model').and_return(sda_model)
        result = Facter::Resolvers::Linux::Disk.resolve(:sda_model)

        expect(result).to eq(sda_model)
      end
    end
    context 'when sda_size exists' do
      let(:sda_size) { 21474836480 * 1024 }
      it 'returns sda_size' do
        allow(File).to receive(:read).with('/sys/block/sda/size').and_return(sda_size)
        result = Facter::Resolvers::Linux::Disk.resolve(:sda_size)

        expect(result).to eq(sda_size)
      end
    end
    context 'when sda_vendor exists' do
      let(:sda_vendor) { 'VMware' }
      it 'returns sda_vendor' do
        allow(File).to receive(:read).with('/sys/block/sda/device/vendor').and_return(sda_vendor)
        result = Facter::Resolvers::Linux::Disk.resolve(:sda_vendor)

        expect(result).to eq(sda_vendor)
      end
    end
  end
end
