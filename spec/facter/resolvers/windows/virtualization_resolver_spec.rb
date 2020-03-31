# frozen_string_literal: true

describe Facter::Resolvers::Virtualization do
  let(:logger) { instance_spy(Facter::Log) }

  before do
    win = double('Win32Ole')

    allow(Win32Ole).to receive(:new).and_return(win)
    allow(win).to receive(:exec_query).with('SELECT Manufacturer,Model,OEMStringArray FROM Win32_ComputerSystem')
                                      .and_return(comp)
    Facter::Resolvers::Virtualization.instance_variable_set(:@log, logger)
  end

  describe '#resolve VirtualBox' do
    after do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) do
      [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: vbox_version),
       double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: vbox_revision)]
    end
    let(:model) { 'VirtualBox' }
    let(:manufacturer) {}
    let(:vbox_version) { 'vboxVer_6.0.4' }
    let(:vbox_revision) { 'vboxRev_128413' }

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('virtualbox')
    end

    it 'detects that is virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('true')
    end

    it 'detects oem_strings facts' do
      expect(Facter::Resolvers::Virtualization.resolve(:oem_strings)).to eql([vbox_version, vbox_revision])
    end
  end

  describe '#resolve Vmware' do
    after do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) { [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: '')] }
    let(:model) { 'VMware' }
    let(:manufacturer) {}

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('vmware')
    end

    it 'detects that is virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('true')
    end
  end

  describe '#resolve KVM' do
    after do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) { [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: '')] }
    let(:model) { 'KVM10' }
    let(:manufacturer) {}

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('kvm')
    end

    it 'detects that is virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('true')
    end
  end

  describe '#resolve Openstack VM' do
    after do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) { [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: '')] }
    let(:model) { 'OpenStack' }
    let(:manufacturer) {}

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('openstack')
    end

    it 'detects that is virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('true')
    end
  end

  describe '#resolve Microsoft VM' do
    after do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) { [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: '')] }
    let(:model) { 'Virtual Machine' }
    let(:manufacturer) { 'Microsoft' }

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('hyperv')
    end

    it 'detects that is virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('true')
    end
  end

  describe '#resolve Xen VM' do
    after do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) { [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: '')] }
    let(:model) { '' }
    let(:manufacturer) { 'Xen' }

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('xen')
    end

    it 'detects that is virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('true')
    end
  end

  describe '#resolve Amazon EC2 VM' do
    after do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) { [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: '')] }
    let(:model) { '' }
    let(:manufacturer) { 'Amazon EC2' }

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('kvm')
    end

    it 'detects that is virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('true')
    end
  end

  describe '#resolve Physical Machine' do
    let(:comp) { [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: '')] }
    let(:model) { '' }
    let(:manufacturer) { '' }

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('physical')
    end

    it 'detects that is not virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('false')
    end
  end

  describe '#resolve should cache facts in the same run' do
    let(:comp) { [double('WIN32OLE', Model: model, Manufacturer: manufacturer, OEMStringArray: '')] }
    let(:model) { '' }
    let(:manufacturer) { 'Amazon EC2' }

    it 'detects virtual machine model' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('physical')
    end

    it 'detects that is virtual' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('false')
    end
  end

  describe '#resolve  when WMI query returns nil' do
    before do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) { nil }

    it 'logs that query failed and virtual nil' do
      allow(logger).to receive(:debug)
        .with('WMI query returned no results'\
                                      ' for Win32_ComputerSystem with values Manufacturer, Model and OEMStringArray.')
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to be(nil)
    end

    it 'detects that is_virtual nil' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to be(nil)
    end
  end

  describe '#resolve when WMI query returns nil for Model and Manufacturer' do
    before do
      Facter::Resolvers::Virtualization.invalidate_cache
    end

    let(:comp) { [double('WIN32OLE', Model: nil, Manufacturer: nil, OEMStringArray: '')] }

    it 'detects that is physical' do
      expect(Facter::Resolvers::Virtualization.resolve(:virtual)).to eql('physical')
    end

    it 'detects that is_virtual is false' do
      expect(Facter::Resolvers::Virtualization.resolve(:is_virtual)).to eql('false')
    end
  end
end
