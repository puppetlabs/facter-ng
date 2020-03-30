# frozen_string_literal: true

describe Facter::InternalFactLoader do
  before do
    os_detector_mock = instance_double(OsDetector)
    allow(os_detector_mock).to receive(:hierarchy).and_return([:Debian])
    allow(OsDetector).to receive(:instance).and_return(os_detector_mock)
  end

  describe '#initialize' do
    context 'when loading facts' do
      it 'loads one legacy fact' do
        os_detector_mock = instance_double(OsDetector)
        allow(os_detector_mock).to receive(:hierarchy).and_return([:Windows])
        allow(OsDetector).to receive(:instance).and_return(os_detector_mock)

        class_discoverer_mock = instance_double(Facter::ClassDiscoverer)
        allow(class_discoverer_mock)
          .to receive(:discover_classes)
          .with(:Windows)
          .and_return([Facts::Windows::NetworkInterfaces])
        allow(Facter::ClassDiscoverer).to receive(:instance).and_return(class_discoverer_mock)

        stub_const('Facts::Windows::NetworkInterfaces::FACT_NAME', 'network_.*')

        internal_fact_loader = Facter::InternalFactLoader.new
        legacy_facts = internal_fact_loader.legacy_facts
        core_facts = internal_fact_loader.core_facts

        expect(legacy_facts.size).to eq(1)
        expect(core_facts.size).to eq(0)
        expect(legacy_facts.first.type).to eq(:legacy)
      end

      it 'loads one core fact' do
        class_discoverer_mock = instance_double(Facter::ClassDiscoverer)
        allow(class_discoverer_mock)
          .to receive(:discover_classes)
          .with(:Debian)
          .and_return([Facts::Debian::Os::Name])
        allow(Facter::ClassDiscoverer).to receive(:instance).and_return(class_discoverer_mock)

        stub_const('Facts::Debian::OsName::FACT_NAME', 'os.name')

        internal_fact_loader = Facter::InternalFactLoader.new
        core_facts = internal_fact_loader.core_facts

        expect(core_facts.size).to eq(1)
        expect(core_facts.first.type).to eq(:core)
      end

      it 'loads one legacy fact and one core fact' do
        os_detector_mock = instance_double(OsDetector)
        allow(os_detector_mock).to receive(:hierarchy).and_return([:Windows])
        allow(OsDetector).to receive(:instance).and_return(os_detector_mock)

        class_discoverer_mock = instance_double(Facter::ClassDiscoverer)
        allow(class_discoverer_mock)
          .to receive(:discover_classes)
          .with(:Windows)
          .and_return([Facts::Windows::NetworkInterfaces, Facts::Windows::Path])
        allow(Facter::ClassDiscoverer).to receive(:instance).and_return(class_discoverer_mock)

        stub_const('Facts::Windows::NetworkInterface::FACT_NAME', 'network_.*')
        stub_const('Facts::Windows::OsName::FACT_NAME', 'path')

        internal_fact_loader = Facter::InternalFactLoader.new
        all_facts = internal_fact_loader.facts

        expect(all_facts.size).to eq(2)
        expect(all_facts.find { |loaded_fact| loaded_fact.type == :core }.type).to eq(:core)
        expect(all_facts.find { |loaded_fact| loaded_fact.type == :legacy }.type).to eq(:legacy)
      end

      it 'loads no facts' do
        class_discoverer_mock = instance_double(Facter::ClassDiscoverer)
        allow(class_discoverer_mock)
          .to receive(:discover_classes)
          .with(:Debian)
          .and_return([])
        allow(Facter::ClassDiscoverer).to receive(:instance).and_return(class_discoverer_mock)

        internal_fact_loader = Facter::InternalFactLoader.new
        all_facts_hash = internal_fact_loader.facts

        expect(all_facts_hash.size).to eq(0)
      end
    end

    context 'when loading hierarchy of facts' do
      before do
        os_detector_mock = instance_double(OsDetector)
        allow(os_detector_mock).to receive(:hierarchy).and_return(%i[Debian El])
        allow(OsDetector).to receive(:instance).and_return(os_detector_mock)

        class_discoverer_mock = instance_double(Facter::ClassDiscoverer)
        allow(class_discoverer_mock)
          .to receive(:discover_classes)
          .with(:Debian)
          .and_return([Facts::Debian::Path])
        allow(class_discoverer_mock)
          .to receive(:discover_classes)
          .with(:El)
          .and_return([Facts::El::Path])
        allow(Facter::ClassDiscoverer).to receive(:instance).and_return(class_discoverer_mock)

        stub_const('Facts::Debian::Path::FACT_NAME', 'path')
        stub_const('Facts::El::Path::FACT_NAME', 'path')
      end

      let(:internal_fact_loader) { Facter::InternalFactLoader.new }

      it 'loads one fact' do
        internal_fact_loader = Facter::InternalFactLoader.new

        expect(internal_fact_loader.facts.size).to eq(1)
      end

      it 'loads path fact' do
        internal_fact_loader = Facter::InternalFactLoader.new

        expect(internal_fact_loader.facts.first.name).to eq('path')
      end

      it 'loads only el path' do
        internal_fact_loader = Facter::InternalFactLoader.new

        expect(internal_fact_loader.facts.first.klass).to eq(Facts::El::Path)
      end
    end
  end
end
