# frozen_string_literal: true

describe 'MemoryResolver' do
  before do
    allow(File).to receive(:read)
      .with('/proc/meminfo')
      .and_return('MemTotal: 4133560320 kB
                    MemFree: 6589915136 kB
                    SwapTotal: 0 kB
                    SwapFree: 0 kB')
  end
  it 'returns total memory' do
    result = Facter::Resolvers::Linux::Memory.resolve(:total)

    expect(result).to eq(4_133_560_320)
  end

  it 'returns memfree' do
    result = Facter::Resolvers::Linux::Memory.resolve(:memfree)

    expect(result).to eq(6_589_915_136)
  end

  it 'returns swap total' do
    result = Facter::Resolvers::Linux::Memory.resolve(:swap_total)

    expect(result).to eq(0)
  end

  it 'returns swap available' do
    result = Facter::Resolvers::Linux::Memory.resolve(:swap_free)

    expect(result).to eq(0)
  end
end
