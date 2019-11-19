# frozen_string_literal: true

describe 'DiskResolver' do
  describe '#resolve' do
    it 'returns sr0_size' do
      result = Facter::Resolvers::Linux::Disk.resolve(:sr0_size)

      expect(result).to eq(1_073_741_312 * 1024)
    end
    it 'returns sr0_model' do
      result = Facter::Resolvers::Linux::Disk.resolve(:sr0_model)

      expect(result).to eq('VMware IDE CDR00')
    end
    it 'returns sr0_vendor' do
      result = Facter::Resolvers::Linux::Disk.resolve(:sr0_vendor)

      expect(result).to eq('NECVMWar')
    end
    it 'returns sda_size' do
      result = Facter::Resolvers::Linux::Disk.resolve(:sda_size)

      expect(result).to eq(21_474_836_480 * 1024)
    end
    it 'returns sda_model' do
      result = Facter::Resolvers::Linux::Disk.resolve(:sda_model)

      expect(result).to eq('Virtual disk')
    end
    it 'returns sda_vendor' do
      result = Facter::Resolvers::Linux::Disk.resolve(:sda_vendor)

      expect(result).to eq('VMware')
    end
  end
end
