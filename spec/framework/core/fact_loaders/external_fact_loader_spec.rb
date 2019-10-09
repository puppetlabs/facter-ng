# frozen_string_literal: true

describe 'CustomFactLoader' do
  describe '#initialize' do
    let(:collection) { double(LegacyFacter::Util::Collection) }

    before do
      allow(LegacyFacter).to receive(:collection).and_return(collection)
    end

    it 'loads one custom fact' do
      allow(collection).to receive(:custom_facts).and_return('os' => nil)
      custom_fact_loader = Facter::ExternalFactLoader.new

      expect(custom_fact_loader.custom_facts).to eq('os' => nil)
    end

    it 'loads no custom facts' do
      allow(collection).to receive(:custom_facts).and_return({})
      custom_fact_loader = Facter::ExternalFactLoader.new

      expect(custom_fact_loader.custom_facts).to eq({})
    end
  end
end
