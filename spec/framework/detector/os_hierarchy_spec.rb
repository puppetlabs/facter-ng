# frozen_string_literal: true

describe Facter::OsHierarchy do
  subject(:os_hierarchy) { Facter::OsHierarchy.new }

  before do
    allow(Facter::Util::FileHelper)
      .to receive(:safe_read)
      .with('os_hierarchy.json')
      .and_return(load_fixture('os_hierarchy').read)
  end

  describe '#construct_hierarchy' do
    context 'when searched_os is ubuntu' do
      it 'constructs hierarchy' do
        hierarchy = os_hierarchy.construct_hierarchy(:ubuntu)

        expect(hierarchy).to eq(%w[Linux Debian Ubuntu])
      end
    end

    context 'when searched_os is nil' do
      it 'constructs hierarchy' do
        hierarchy = os_hierarchy.construct_hierarchy(nil)

        expect(hierarchy).to eq(%w[])
      end
    end

    context 'when searched_os is not in hierarchy' do
      it 'constructs hierarchy' do
        hierarchy = os_hierarchy.construct_hierarchy(:my_os)

        expect(hierarchy).to eq([])
      end
    end
  end
end
