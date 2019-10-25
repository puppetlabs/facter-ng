# frozen_string_literal: true

describe 'MemoryResolver' do
  before do
    allow(File).to receive(:read)
                 .with('/proc/meminfo')
                   .and_return('MemTotal 4133560320 kB
                    MemFree 3853774848 kB
                    SwapTotal 2147479552 kB
                    SwapFree 2147479552 kB')
  end
  it 'returns total memory' do
    result = Facter::Resolvers::Linux::Memory.resolve(:total)

    expect(result).to eq('4133560320')
  end

  it 'returns memfree' do
    result = Facter::Resolvers::Linux::Memory.resolve(:memfree)

    expect(result).to eq('3853774848')
  end

  it 'returns swap total' do
    result = Facter::Resolvers::Linux::Memory.resolve(:swap_total)

    expect(result).to eq('2147479552')
  end

  it 'returns swap available' do
    result = Facter::Resolvers::Linux::Memory.resolve(:swap_free)

    expect(result).to eq('2147479552')
  end
end
