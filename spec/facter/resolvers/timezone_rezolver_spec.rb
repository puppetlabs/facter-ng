# frozen_string_literal: true

describe 'TimezoneResolver' do
  context '#resolve timezone' do
    it 'detects timezone' do
      expect(Facter::Resolvers::TimezoneResolver.resolve(:timezone)).to eql(Time.now.localtime.strftime('%Z'))
    end
  end
end
