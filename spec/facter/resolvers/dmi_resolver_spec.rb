# frozen_string_literal: true

describe 'DmiResolver' do
  describe '#resolve' do
    let(:files) do
      %w[bios_date bios_vendor bios_version board_vendor board_name board_serial
         chassis_asset_tag chassis_type sys_vendor product_name product_serial
         product_uuid]
    end
    let(:test_dir) { '/sys/class/dmi' }
    before do
      allow(File).to receive(:directory?).with(test_dir).and_return(true)
    end
    after do
      Facter::Resolvers::Linux::DmiBios.invalidate_cache
    end

    context 'when directory does not exist' do
      it 'when directory does not exist' do
        allow(File).to receive(:directory?).with(test_dir).and_return(false)
      end
    end

    context 'when bios_date file exists' do
      let(:test_file) { test_dir + 'id/bios_date' }
      let(:bios_release_date) { '12/12/2018' }

      it 'returns bios_release_date' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/bios_date').and_return(bios_release_date)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file
                                                                                 .match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:bios_date)

        expect(result).to eq(bios_release_date)
      end
    end

    context 'when bios_vendor file exists' do
      let(:test_file) { test_dir + 'id/bios_vendor' }
      let(:bios_vendor) { 'Phoenix Technologies LTD' }

      it 'returns bios_vendor' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/bios_vendor').and_return(bios_vendor)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file
                                                                                 .match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:bios_vendor)

        expect(result).to eq(bios_vendor)
      end
    end
    context 'when bios_version file exists' do
      let(:test_file) { test_dir + 'id/bios_version' }
      let(:bios_version) { '6.00' }

      it 'returns bios_version' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/bios_version').and_return(bios_version)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file
                                                                                 .match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:bios_version)

        expect(result).to eq(bios_version)
      end
    end
    context 'when board_vendor file exists' do
      let(:test_file) { test_dir + 'id/board_vendor' }
      let(:board_manufacturer) { 'Intel Corporation' }

      it 'returns board_manufacturer' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/board_vendor').and_return(board_manufacturer)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file
                                                                                 .match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:board_vendor)

        expect(result).to eq(board_manufacturer)
      end
    end
    context 'when board_name file exists' do
      let(:test_file) { test_dir + 'id/board_name' }
      let(:board_name) { '440BX Desktop Reference Platform' }

      it 'returns board_product' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/board_name').and_return(board_name)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file
                                                                                 .match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:board_name)

        expect(result).to eq(board_name)
      end
    end
    context 'when board_serial file exists' do
      let(:test_file) { test_dir + 'id/board_serial' }
      let(:board_serial_number) { 'None' }

      it 'returns board_serial_number' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/board_serial').and_return(board_serial_number)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file.match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:board_serial)

        expect(result).to eq(board_serial_number)
      end
    end
    context 'when chassis_asset_tag file exists' do
      let(:test_file) { test_dir + 'id/chassis_asset_tag' }
      let(:chassis_asset_tag) { 'No Asset Tag' }

      it 'returns chassis_asset_tag' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/chassis_asset_tag').and_return(chassis_asset_tag)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file.match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:chassis_asset_tag)

        expect(result).to eq(chassis_asset_tag)
      end
    end
    context 'when chassis_type file exists' do
      let(:test_file) { test_dir + 'id/chassis_type' }
      let(:chassis_type) { '4' }

      it 'returns chassis_type' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/chassis_type').and_return(chassis_type)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file.match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:chassis_type)

        expect(result).to eq('Pizza Box')
      end
    end
    context 'when sys_vendor file exists' do
      let(:test_file) { test_dir + 'id/sys_vendor' }
      let(:manufacturer) { 'VMware, Inc.' }

      it ' returns manufacturer' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/sys_vendor').and_return(manufacturer)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file.match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:sys_vendor)

        expect(result).to eq(manufacturer)
      end
    end
    context 'when product_name file exists' do
      let(:test_file) { test_dir + 'id/product_name' }
      let(:product_name) { 'VMware Virtual Platform' }

      it 'returns product_name' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/product_name').and_return(product_name)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file.match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:product_name)

        expect(result).to eq(product_name)
      end
    end
    context 'when product_serial file exists' do
      let(:test_file) { test_dir + 'id/product_serial' }
      let(:product_serial_number) { 'VMware-42 1a 02 ea e6 27 76 b8-a1 23 a7 8a d3 12 ee cf' }

      it 'returns product_serial_number' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/product_serial').and_return(product_serial_number)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file.match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:product_serial)

        expect(result).to eq(product_serial_number)
      end
    end
    context 'when product_uuid file exists' do
      let(:test_file) { test_dir + 'id/product_uuid' }
      let(:product_uuid) { 'ea021a42-27e6-b876-a123-a78ad312eecf' }

      it 'returns product_uuid' do
        allow(File).to receive(:read).with('/sys/class/dmi/id/product_uuid').and_return(product_uuid)
        files.each do |file|
          allow(File).to receive(:read).with("/sys/class/dmi/id/#{file}") unless test_file.match(file)
        end
        result = Facter::Resolvers::Linux::DmiBios.resolve(:product_uuid)

        expect(result).to eq(product_uuid)
      end
    end
  end
end
