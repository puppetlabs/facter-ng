# frozen_string_literal: true

describe 'TimezoneResolver' do
  describe '#resolve timezone' do
    it 'detects timezone' do
      expect(Facter::Resolvers::Timezone.resolve(:timezone)).to eql(Time.now.localtime.strftime('%Z'))
    end
  end
end
