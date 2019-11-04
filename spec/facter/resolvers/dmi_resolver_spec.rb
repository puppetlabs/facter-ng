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
                       .with('/sys/class/dmi/bios_date')
  end
  it 'returns bios_release_date' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:bios_release_date)

    expect(result).to eq(bios_release_date)
  end

  it 'returns bios_vendor' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:bios_vendor)

    expect(result).to eq(bios_vendor)
  end

  it 'returns bios_version' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:bios_version)

    expect(result).to eq(bios_version)
  end

  it 'returns board_manufacturer' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:board_manufacturer)

    expect(result).to eq(board_manufacturer)
  end

  it 'returns board_product' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:board_product)

    expect(result).to eq(board_product)
  end

  it 'returns board_serial_number' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:board_serial_number)

    expect(result).to eq(board_serial_number)
  end

  it 'returns chassis_asset_tag' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:chassis_asset_tag)

    expect(result).to eq(chassis_asset_tag)
  end

  it 'returns chassis_type' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:chassis_type)

    expect(result).to eq(chassis_type)
  end

  it ' returns manufacturer' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:manufacturer)

    expect(result).to eq(manufacturer)
  end

  it 'returns product_name' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:product_name)

    expect(result).to eq(product_name)
  end

  it 'returns product_serial_number' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:product_serial_number)

    expect(result).to eq(product_serial_number)
  end

  it 'returns product_uuid' do
    result = Facter::Resolvers::Linux::DMIBios.resolve(:product_uuid)

    expect(result).to eq(product_uuid)
  end
end
