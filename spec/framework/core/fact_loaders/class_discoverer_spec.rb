# frozen_string_literal: true

describe 'ClassDiscoverer' do
  describe '#discover_classes' do
    before do
      load_lib_dirs('facts', 'linux', '**')
    end

    it 'loads all classes' do
      allow_any_instance_of(Module).to receive(:constants).and_return(%i[Path OsName])

      expect(Facter::ClassDiscoverer.instance.discover_classes('Linux')).to eq(%i[Path OsName])
    end

    it 'loads no classes' do
      allow_any_instance_of(Module).to receive(:constants).and_return([])

      expect(Facter::ClassDiscoverer.instance.discover_classes('Ubuntu')).to eq([])
    end
  end
end
