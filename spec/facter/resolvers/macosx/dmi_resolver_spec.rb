# frozen_string_literal: true

describe 'DmiResolver' do
  describe '#resolve' do
    let(:model) { 'MacBookPro11,4' }
    it 'receive model' do
      result = Facter::Resolvers::Macosx::DmiBios.resolve(:model)

      expect(result).to eql(model)
    end
  end
end
