# frozen_string_literal: true

describe Facter::InternalFactLoader do
  before do
    allow_any_instance_of(OsDetector).to receive(:hierarchy).and_return([:Debian])
  end

  describe '#initialize' do
    context 'load facts' do
      it 'loads one legacy fact' do
        allow_any_instance_of(OsDetector).to receive(:hierarchy).and_return([:Windows])
        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Windows)
          .and_return([Facts::Windows::NetworkInterfaces])

        stub_const('Facts::Windows::NetworkInterfaces::FACT_NAME', 'network_.*')

        internal_fact_loader = Facter::InternalFactLoader.new
        legacy_facts = internal_fact_loader.legacy_facts
        core_facts = internal_fact_loader.core_facts

        expect(legacy_facts.size).to eq(1)
        expect(core_facts.size).to eq(0)
        expect(legacy_facts.first.type).to eq(:legacy)
      end

      it 'loads one core fact' do
        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Debian)
          .and_return([Facts::Debian::Os::Name])

        stub_const('Facts::Debian::OsName::FACT_NAME', 'os.name')

        internal_fact_loader = Facter::InternalFactLoader.new
        core_facts = internal_fact_loader.core_facts

        expect(core_facts.size).to eq(1)
        expect(core_facts.first.type).to eq(:core)
      end

      it 'loads one legacy fact and one core fact' do
        allow_any_instance_of(OsDetector).to receive(:hierarchy).and_return([:Windows])

        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Windows)
          .and_return([Facts::Windows::NetworkInterfaces, Facts::Windows::Path])

        stub_const('Facts::Windows::NetworkInterface::FACT_NAME', 'network_.*')
        stub_const('Facts::Windows::OsName::FACT_NAME', 'path')

        internal_fact_loader = Facter::InternalFactLoader.new
        all_facts = internal_fact_loader.facts

        expect(all_facts.size).to eq(2)
        expect(all_facts.find { |loaded_fact| loaded_fact.type == :core }.type).to eq(:core)
        expect(all_facts.find { |loaded_fact| loaded_fact.type == :legacy }.type).to eq(:legacy)
      end

      it 'loads no facts' do
        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Debian)
          .and_return([])
        internal_fact_loader = Facter::InternalFactLoader.new
        all_facts_hash = internal_fact_loader.facts

        expect(all_facts_hash.size).to eq(0)
      end
    end

    context 'load hierarchy of facts' do
      before do
        allow_any_instance_of(OsDetector).to receive(:hierarchy).and_return(%i[Debian El])

        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Debian)
          .and_return([Facts::Debian::Path])

        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:El)
          .and_return([Facts::El::Path])

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
