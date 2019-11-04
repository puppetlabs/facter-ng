# frozen_string_literal: true

describe 'DmiResolver' do
  let(:bios_release_date) { '12/12/2018' }
  let(:bios_vendor) { 'Phoenix Technologies LTD' }
  let(:bios_version) { '6.00' }
  let(:board_manufacturer) { 'Intel Corporation' }
  let(:board_product) { '440BX Desktop Reference Platform' }
  let(:board_serial_number) { 'None' }
  let(:chassis_asset_tag) { 'No Asset Tag' }
  let(:chassis_type) { 'Other' }
  let(:manufacturer) { 'VMware, Inc.' }
  let(:product_name) { 'VMware Virtual Platform' }
  let(:product_serial_number) { 'VMware-42 1a 02 ea e6 27 76 b8-a1 23 a7 8a d3 12 ee cf' }
  let(:product_uuid) { 'ea021a42-27e6-b876-a123-a78ad312eecf' }

  before do
    allow(File).to receive(:read)
                       .with('/proc/meminfo')
                       .and_return(load_fixture('meminfo').read)
  end
  it 'returns total memory' do
    result = Facter::Resolvers::Linux::Memory.resolve(:total)

    expect(result).to eq(total)
  end

  it 'returns memfree' do
    result = Facter::Resolvers::Linux::Memory.resolve(:memfree)

    expect(result).to eq(free)
  end

  it 'returns swap total' do
    result = Facter::Resolvers::Linux::Memory.resolve(:swap_total)

    expect(result).to eq(swap_total)
  end

  it 'returns swap available' do
    result = Facter::Resolvers::Linux::Memory.resolve(:swap_free)

    expect(result).to eq(swap_free)
  end

  it 'returns swap capacity' do
    result = Facter::Resolvers::Linux::Memory.resolve(:swap_capacity)
    swap_capacity = format('%.2f', (swap_used / swap_total.to_f * 100)) + '%'

    expect(result).to eq(swap_capacity)
  end

  it 'returns swap usage' do
    result = Facter::Resolvers::Linux::Memory.resolve(:swap_used_bytes)

    expect(result).to eq(swap_used)
  end

  it 'returns system capacity' do
    result = Facter::Resolvers::Linux::Memory.resolve(:capacity)
    system_capacity = format('%.2f', (used / total.to_f * 100)) + '%'

    expect(result).to eq(system_capacity)
  end

  it 'returns system usage' do
    result = Facter::Resolvers::Linux::Memory.resolve(:used_bytes)

    expect(result).to eq(used)
  end
end
