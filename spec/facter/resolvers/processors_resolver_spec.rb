# frozen_string_literal: true

describe Facter::Resolvers::Linux::Processors do
  let(:processors) { 4 }
  let(:models) do
    ['Intel(R) Xeon(R) CPU E5-2697 v4 @ 2.30GHz', 'Intel(R) Xeon(R) CPU E5-2697 v4 @ 2.30GHz',
     'Intel(R) Xeon(R) CPU E5-2697 v4 @ 2.30GHz', 'Intel(R) Xeon(R) CPU E5-2697 v4 @ 2.30GHz']
  end
  let(:physical_processors) { 1 }

  context 'when cpuingo file is readable' do
    before do
      allow(Facter::Util::FileHelper).to receive(:safe_readlines)
        .with('/proc/cpuinfo')
        .and_return(load_fixture('cpuinfo').readlines)
    end

    after do
      Facter::Resolvers::Linux::Processors.invalidate_cache
    end

    it 'returns number of processors' do
      result = Facter::Resolvers::Linux::Processors.resolve(:processors)

      expect(result).to eq(processors)
    end

    it 'returns list of models' do
      result = Facter::Resolvers::Linux::Processors.resolve(:models)

      expect(result).to eq(models)
    end

    it 'returns number of physical processors' do
      result = Facter::Resolvers::Linux::Processors.resolve(:physical_count)

      expect(result).to eq(physical_processors)
    end
  end

  context 'when cpuinfo is not readable' do
    before do
      allow(Facter::Util::FileHelper).to receive(:safe_readlines)
        .with('/proc/cpuinfo')
        .and_return([])
    end

    it 'returns nil' do
      result = Facter::Resolvers::Linux::Processors.resolve(:physical_count)

      expect(result).to be(nil)
    end
  end
end
