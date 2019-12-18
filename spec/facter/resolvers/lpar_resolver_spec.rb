# frozen_string_literal: true

describe 'Lpar' do
  context '#oslevel 6.1' do
    before do
      expect(Open3).to receive(:capture2)
        .with('/usr/bin/oslevel 2>/dev/null')
        .and_return('6.1.0.0')

      prstat_i = <<-OUTPUT
  Partition Name                             : aix61-6
  Partition Number                           : 15
  Sub Processor Mode                         : -WPAR Key                                   : 13
  WPAR Configured ID                         : 14
      OUTPUT
      expect(Open3).to receive(:capture2)
        .with('/usr/bin/lparstat -i -W')
        .and_return(prstat_i)

      Facter::Resolvers::Lpar.invalidate_cache
      Facter::Resolvers::Lpar.instance_variable_set(:@supports_wpar, nil)
    end

    it 'returns build' do
      expect(Facter::Resolvers::Lpar.resolve(:lpar_partition_name))   .to eq('aix61-6')
      expect(Facter::Resolvers::Lpar.resolve(:lpar_partition_number)) .to eq(15)
      expect(Facter::Resolvers::Lpar.resolve(:wpar_key))              .to eq(13)
      expect(Facter::Resolvers::Lpar.resolve(:wpar_configured_id))    .to eq(14)
    end
  end

  context '#oslevel 6.0' do
    before do
      expect(Open3).to receive(:capture2)
        .with('/usr/bin/oslevel 2>/dev/null')
        .and_return('6.0.0.0').exactly(3).times

      prstat_i = <<-OUTPUT
  Partition Name                             : aix61-6
  Partition Number                           : 15
      OUTPUT
      expect(Open3).to receive(:capture2)
        .with('/usr/bin/lparstat -i')
        .and_return(prstat_i).exactly(3).times

      Facter::Resolvers::Lpar.invalidate_cache
      Facter::Resolvers::Lpar.instance_variable_set(:@supports_wpar, nil)
    end

    it 'returns build' do
      expect(Facter::Resolvers::Lpar.resolve(:lpar_partition_name))   .to eq('aix61-6')
      expect(Facter::Resolvers::Lpar.resolve(:lpar_partition_number)) .to eq(15)
      expect(Facter::Resolvers::Lpar.resolve(:wpar_key))              .to be_nil
      expect(Facter::Resolvers::Lpar.resolve(:wpar_configured_id))    .to be_nil
    end
  end
end
