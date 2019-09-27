#! /usr/bin/env ruby

require_relative '../../spec_helper_legacy'

describe Facter::Util::Loader do
  def loader_from(places)
    env = places[:env] || {}
    search_path = places[:search_path] || []
    loader = Facter::Util::Loader.new(env)
    allow(loader).to receive(:search_path).and_return(search_path)
    loader
  end

  it "should have a method for loading individual facts by name" do
    expect(Facter::Util::Loader.new).to respond_to(:load)
  end

  it "should have a method for loading all facts" do
    expect(Facter::Util::Loader.new).to respond_to(:load_all)
  end

  it "should have a method for returning directories containing facts" do
    expect(Facter::Util::Loader.new).to respond_to(:search_path)
  end

  describe "#valid_seach_path?" do
    let(:loader) { Facter::Util::Loader.new }

    # Used to have test for " " as a directory since that should
    # be a relative directory, but on Windows in both 1.8.7 and
    # 1.9.3 it is an absolute directory (WTF Windows). Considering
    # we didn't have a valid use case for a " " directory, the
    # test was removed.

    [
      '.',
      '..',
      '...',
      '.foo',
      '../foo',
      'foo',
      'foo/bar',
      'foo/../bar',
      ' /',
      ' \/',
    ].each do |dir|
      it "should be false for relative path #{dir}" do puts loader.inspect
        expect(loader.send(:valid_search_path?, dir)).to be false
      end
    end
    [
      '/.',
      '/..',
      '/...',
      '/.foo',
      '/../foo',
      '/foo',
      '/foo/bar',
      '/foo/../bar',
      '/ ',
      '/ /..',
    ].each do |dir|
      it "should be true for absolute path #{dir}" do
        expect(loader.send(:valid_search_path?, dir)).to be true
      end
    end
  end

  describe "when determining the search path" do
    let(:loader) { Facter::Util::Loader.new }

    it "should include the facter subdirectory of all paths in ruby LOAD_PATH" do
      dirs = $LOAD_PATH.collect { |d| File.expand_path('custom_facts', d) }
      allow(loader).to receive(:valid_search_path?).and_return(true)
      allow(File).to receive(:directory?).and_return true

      paths = loader.search_path

      dirs.each do |dir|
        expect(paths).to include(dir)
      end
    end

    it "should exclude invalid search paths" do
      dirs = $LOAD_PATH.collect { |d| File.join(d, "custom_facts") }
      allow(loader).to receive(:valid_search_path?).and_return(false)
      paths = loader.search_path
      dirs.each do |dir|
        expect(paths).not_to include(dir)
      end
    end

    it "should include all search paths registered with Facter" do
      allow(Facter).to receive(:search_path).and_return %w{/one /two}
      allow(loader).to receive(:valid_search_path?).and_return true

      allow(File).to receive(:directory?).and_return false
      allow(File).to receive(:directory?).with('/one').and_return true
      allow(File).to receive(:directory?).with('/two').and_return true

      paths = loader.search_path
      expect(paths).to include("/one")
      expect(paths).to include("/two")
    end

    it "should warn on invalid search paths registered with Facter" do
      expect(Facter).to receive(:search_path).and_return %w{/one two/three}
      allow(loader).to receive(:valid_search_path?).and_return false
      allow(loader).to receive(:valid_search_path?).with('/one').and_return true
      allow(loader).to receive(:valid_search_path?).with('two/three').and_return false
      expect(Facter).to receive(:warn).with('Excluding two/three from search path. Fact file paths must be an absolute directory').once

      allow(File).to receive(:directory?).and_return false
      allow(File).to receive(:directory?).with('/one').and_return true

      paths = loader.search_path
      expect(paths).to include("/one")
      expect(paths).not_to include("two/three")
    end

    it "should strip paths that are valid paths but not are not present" do
      expect(Facter).to receive(:search_path).and_return %w{/one /two}
      allow(loader).to receive(:valid_search_path?).and_return false
      allow(loader).to receive(:valid_search_path?).with('/one').and_return true
      allow(loader).to receive(:valid_search_path?).with('/two').and_return true

      allow(File).to receive(:directory?).and_return false
      allow(File).to receive(:directory?).with('/one').and_return true
      allow(File).to receive(:directory?).with('/two').and_return false

      paths = loader.search_path
      expect(paths).to include("/one")
      expect(paths).not_to include('/two')
    end

    describe "and the FACTERLIB environment variable is set" do
      it "should include all paths in FACTERLIB" do
        loader = Facter::Util::Loader.new("FACTERLIB" => "/one/path#{File::PATH_SEPARATOR}/two/path")

        allow(File).to receive(:directory?).and_return false
        allow(File).to receive(:directory?).with('/one/path').and_return true
        allow(File).to receive(:directory?).with('/two/path').and_return true

        allow(loader).to receive(:valid_search_path?).and_return true
        paths = loader.search_path
        %w{/one/path /two/path}.each do |dir|
          expect(paths).to include(dir)
        end
      end
    end
  end

  describe "when loading facts" do
    it "should load values from the matching environment variable if one is present" do
      loader = loader_from(:env => { "facter_testing" => "yayness" })

      expect(Facter).to receive(:add).with("testing")

      loader.load(:testing)
    end

    it "should load any files in the search path with names matching the fact name" do
      loader = loader_from(:search_path => %w{/one/dir /two/dir})

      expect(loader).to receive(:search_path).and_return %w{/one/dir /two/dir}
      allow(File).to receive(:file?).and_return false
      allow(File).to receive(:file?).with("/one/dir/testing.rb").and_return true

      expect(Kernel).to receive(:load).with("/one/dir/testing.rb")

      loader.load(:testing)
    end

    it 'should not load any ruby files from subdirectories matching the fact name in the search path' do
      loader = Facter::Util::Loader.new
      allow(File).to receive(:file?).and_return false
      expect(File).to receive(:file?).with("/one/dir/testing.rb").and_return true
      expect(Kernel).to receive(:load).with("/one/dir/testing.rb")

      allow(File).to receive(:directory?).with("/one/dir/testing").and_return true
      allow(loader).to receive(:search_path).and_return %w{/one/dir}

      allow(Dir).to receive(:entries).with("/one/dir/testing").and_return %w{foo.rb bar.rb}
      %w{/one/dir/testing/foo.rb /one/dir/testing/bar.rb}.each do |f|
        allow(File).to receive(:directory?).with(f).and_return false
        allow(Kernel).to receive(:load).with(f)
      end

      loader.load(:testing)
    end

    it "should not load files that don't end in '.rb'" do
      loader = Facter::Util::Loader.new
      expect(loader).to receive(:search_path).and_return %w{/one/dir}
      allow(File).to receive(:file?).and_return false
      expect(File).to receive(:file?).with("/one/dir/testing.rb").and_return false
      expect(File).to receive(:exist?).with("/one/dir/testing").never
      expect(Kernel).to receive(:load).never

      loader.load(:testing)
    end
  end

  describe "when loading all facts" do
    let(:loader) { Facter::Util::Loader.new }

    before :each do
      allow(loader).to receive(:search_path).and_return([])

      allow(File).to receive(:directory?).and_return true
    end

    it "should load all files in all search paths" do
      loader = loader_from(:search_path => %w{/one/dir /two/dir})

      allow(Dir).to receive(:glob).with('/one/dir/*.rb').and_return %w{/one/dir/a.rb /one/dir/b.rb}
      allow(Dir).to receive(:glob).with('/two/dir/*.rb').and_return %w{/two/dir/c.rb /two/dir/d.rb}

      %w{/one/dir/a.rb /one/dir/b.rb /two/dir/c.rb /two/dir/d.rb}.each do |f|
        expect(File).to receive(:file?).with(f).and_return true
        expect(Kernel).to receive(:load).with(f)
      end

      loader.load_all
    end

    it "should not try to load subdirectories of search paths" do
      expect(loader).to receive(:search_path).and_return %w{/one/dir /two/dir}

      # a.rb is a directory
      expect(Dir).to receive(:glob).with('/one/dir/*.rb').and_return %w{/one/dir/a.rb /one/dir/b.rb}
      expect(File).to receive(:file?).with('/one/dir/a.rb').and_return false
      expect(File).to receive(:file?).with('/one/dir/b.rb').and_return true
      expect(Kernel).to receive(:load).with('/one/dir/b.rb')

      # c.rb is a directory
      expect(Dir).to receive(:glob).with('/two/dir/*.rb').and_return %w{/two/dir/c.rb /two/dir/d.rb}
      expect(File).to receive(:file?).with('/two/dir/c.rb').and_return false
      expect(File).to receive(:file?).with('/two/dir/d.rb').and_return true
      expect(Kernel).to receive(:load).with('/two/dir/d.rb')

      loader.load_all
    end

    it "should not raise an exception when a file is unloadable" do
      expect(loader).to receive(:search_path).and_return %w{/one/dir}

      expect(Dir).to receive(:glob).with('/one/dir/*.rb').and_return %w{/one/dir/a.rb}
      expect(File).to receive(:file?).with('/one/dir/a.rb').and_return true

      expect(Kernel).to receive(:load).with("/one/dir/a.rb").and_raise(LoadError)
      expect(Facter).to receive(:warn)

      expect { loader.load_all }.not_to raise_error
    end

    it "should load all facts from the environment" do
      Facter::Util::Resolution.with_env "facter_one" => "yayness", "facter_two" => "boo" do
        loader.load_all
      end
      expect(Facter.value(:one)).to eq 'yayness'
      expect(Facter.value(:two)).to eq 'boo'
    end

    it "should only load all facts one time" do
      loader = loader_from(:env => {})
      expect(loader).to receive(:load_env).once

      loader.load_all
      loader.load_all
    end
  end

  it "should load facts on the facter search path only once" do
    loader = loader_from(:env => {})
    loader.load_all

    expect(loader).to receive(:kernel_load).with(/ec2/).never
    loader.load(:ec2)
  end
end
