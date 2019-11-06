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

  it 'returns bios_release_date' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/bios_date').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/bios_date').and_return(bios_release_date)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:bios_date)

    expect(result).to eq(bios_release_date)
  end

  it 'returns bios_vendor' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/bios_vendor').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/bios_vendor').and_return(bios_vendor)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:bios_vendor)

    expect(result).to eq(bios_vendor)
  end

  it 'returns bios_version' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/bios_version').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/bios_version').and_return(bios_version)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:bios_version)

    expect(result).to eq(bios_version)
  end

  it 'returns board_manufacturer' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/board_vendor').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/board_vendor').and_return(board_manufacturer)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:board_vendor)

    expect(result).to eq(board_manufacturer)
  end

  it 'returns board_product' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/board_name').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/board_name').and_return(board_product)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:board_name)

    expect(result).to eq(board_product)
  end

  it 'returns board_serial_number' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/board_serial').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/board_serial').and_return(board_serial_number)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:board_serial)

    expect(result).to eq(board_serial_number)
  end

  it 'returns chassis_asset_tag' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/chassis_asset_tag').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/chassis_asset_tag').and_return(chassis_asset_tag)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:chassis_asset_tag)

    expect(result).to eq(chassis_asset_tag)
  end

  it 'returns chassis_type' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/chassis_type').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/chassis_type').and_return(chassis_type)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:chassis_type)

    expect(result).to eq(chassis_type)
  end

  it ' returns manufacturer' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/sys_vendor').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/sys_vendor').and_return(manufacturer)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:sys_vendor)

    expect(result).to eq(manufacturer)
  end

  it 'returns product_name' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/product_name').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/product_name').and_return(product_name)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:product_name)

    expect(result).to eq(product_name)
  end

  it 'returns product_serial_number' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/product_serial').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/product_serial').and_return(product_serial_number)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:product_serial)

    expect(result).to eq(product_serial_number)
  end

  it 'returns product_uuid' do
    allow(File).to receive(:exist?).with('/sys/class/dmi/id/product_uuid').and_return(true)
    allow(File).to receive(:read).with('/sys/class/dmi/id/product_uuid').and_return(product_uuid)
    result = Facter::Resolvers::Linux::DMIBios.resolve(:product_uuid)

    expect(result).to eq(product_uuid)
  end
end
