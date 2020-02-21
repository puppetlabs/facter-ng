#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../spec_helper_legacy'

describe LegacyFacter::Util::DirectoryLoader do
  include PuppetlabsSpec::Files

  subject { LegacyFacter::Util::DirectoryLoader.new(tmpdir('directory_loader')) }

  let(:collection) { LegacyFacter::Util::Collection.new(double('internal loader'), subject) }

  it 'makes the directory available' do
    expect(subject.directory).to be_instance_of(String)
  end

  # it "can be created with a given directory" do
  #   expect(Facter::Util::DirectoryLoader.loader_for("lib").directory).to eq "../lib"
  # end

  it 'raises an error when the directory does not exist' do
    missing_dir = 'missing'
    allow(File).to receive(:directory?).with(missing_dir).and_return(false)
    expect { LegacyFacter::Util::DirectoryLoader.loader_for(missing_dir) }
      .to raise_error LegacyFacter::Util::DirectoryLoader::NoSuchDirectoryError
  end

  it "does nothing bad when dir doesn't exist" do
    fakepath = '/foobar/path'
    my_loader = LegacyFacter::Util::DirectoryLoader.new(fakepath)
    expect(FileTest.exists?(my_loader.directory)).to be false
    expect { my_loader.load(collection) }.to_not raise_error
  end

  describe 'when loading facts from disk' do
    it 'is able to load files from disk and set facts' do
      data = { 'f1' => 'one', 'f2' => 'two' }
      write_to_file('data.yaml', YAML.dump(data))

      subject.load(collection)

      expect(collection.value('f1')).to eq 'one'
      expect(collection.value('f2')).to eq 'two'
    end

    it "ignores files that begin with '.'" do
      not_to_be_used_collection = double('collection should not be used')
      expect(not_to_be_used_collection).to receive(:add).never

      data = { 'f1' => 'one', 'f2' => 'two' }
      write_to_file('.data.yaml', YAML.dump(data))

      subject.load(not_to_be_used_collection)
    end

    %w[bak orig].each do |ext|
      it "ignores files with an extension of '#{ext}'" do
        expect(LegacyFacter).to receive(:warn).with(/#{ext}/)
        write_to_file('data' + ".#{ext}", 'foo=bar')

        subject.load(collection)
      end
    end

    it 'warns when trying to parse unknown file types' do
      write_to_file('file.unknownfiletype', 'stuff=bar')
      expect(LegacyFacter).to receive(:warn).with(/file.unknownfiletype/)

      subject.load(collection)
    end

    it 'external facts should almost always precedence over all other facts' do
      collection.add('f1', value: 'lower_weight_fact') do
        has_weight(LegacyFacter::Util::DirectoryLoader::EXTERNAL_FACT_WEIGHT - 1)
      end

      data = { 'f1' => 'external_fact' }
      write_to_file('data.yaml', YAML.dump(data))

      subject.load(collection)

      expect(collection.value('f1')).to eq 'external_fact'
    end

    describe 'given a custom weight' do
      subject { LegacyFacter::Util::DirectoryLoader.new(tmpdir('directory_loader'), 10) }

      it 'sets that weight for loaded external facts' do
        collection.add('f1', value: 'higher_weight_fact') { has_weight(11) }
        data = { 'f1' => 'external_fact' }
        write_to_file('data.yaml', YAML.dump(data))

        subject.load(collection)

        expect(collection.value('f1')).to eq 'higher_weight_fact'
      end
    end
  end

  def write_to_file(file_name, to_write)
    file = File.join(subject.directory, file_name)
    File.open(file, 'w') { |f| f.print to_write }
  end
end
