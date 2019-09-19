# frozen_string_literal: true

describe 'Windows ProductReleaseResolver' do
  let(:reg) { {} }

  before do
    allow(Win32::Registry::HKEY_LOCAL_MACHINE).to receive(:open).with('SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion')
                                                                .and_return(reg)
    allow(reg).to receive(:[]).with('EditionID').and_return(ed)
    allow(reg).to receive(:[]).with('InstallationType').and_return(install)
    allow(reg).to receive(:[]).with('ProductName').and_return(prod)
    allow(reg).to receive(:[]).with('ReleaseId').and_return(release)
    allow(reg).to receive(:close)
  end
  after do
    ProductReleaseResolver.invalidate_cache
  end

  context '#resolve' do
    let(:ed) { 'ServerStandard' }
    let(:install) { 'Server' }
    let(:prod) { 'Windows Server 2019 Standard' }
    let(:release) { '1809' }

    it 'detects edition id' do
      expect(ProductReleaseResolver.resolve(:edition_id)).to eql(ed)
    end

    it 'detects installation type' do
      expect(ProductReleaseResolver.resolve(:installation_type)).to eql(install)
    end

    it 'detects product name' do
      expect(ProductReleaseResolver.resolve(:product_name)).to eql(prod)
    end

    it 'detects release id' do
      expect(ProductReleaseResolver.resolve(:release_id)).to eql(release)
    end
  end
end
