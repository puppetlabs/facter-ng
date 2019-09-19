# frozen_string_literal: true

describe 'OsResolver' do
  before do
    allow(UnameResolver).to receive(:resolve).with(:kernelname).and_return(kernel)
  end
  after do
    OsResolver.invalidate_cache
  end

  context 'Kernel name returns SunOS' do
    let(:kernel) { 'SunOS' }
    it 'returns Solaris if kernel name is SunOS ' do
      result = OsResolver.resolve(:name)
      expect(result).to eq('Solaris')
    end
  end
  context 'Kernel name returns anything else than SunOS' do
    let(:kernel) { 'kernel_name_example' }
    it 'returns the kernel name' do
      result = OsResolver.resolve(:name)
      expect(result).to eq('kernel_name_example')
    end
  end
end
