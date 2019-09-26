require_relative '../../../spec_helper_legacy'

describe Facter::Core::Execution::Windows, :as_platform => :windows do

  describe "#search_paths" do
    it "should use the PATH environment variable to determine locations" do
      ENV.expects(:[]).with('PATH').returns 'C:\Windows;C:\Windows\System32'
      expect(subject.search_paths).to eq %w{C:\Windows C:\Windows\System32}
    end
  end

  describe "#which" do
    before :each do
      subject.stubs(:search_paths).returns ['C:\Windows\system32', 'C:\Windows', 'C:\Windows\System32\Wbem' ]
      ENV.stubs(:[]).with('PATHEXT').returns nil
    end

    context "and provided with an absolute path" do
      it "should return the binary if executable" do
        File.expects(:executable?).with('C:\Tools\foo.exe').returns true
        File.expects(:executable?).with('\\\\remote\dir\foo.exe').returns true
        expect(subject.which('C:\Tools\foo.exe')).to eq 'C:\Tools\foo.exe'
        expect(subject.which('\\\\remote\dir\foo.exe')).to eq '\\\\remote\dir\foo.exe'
      end

      it "should return nil if the binary is not executable" do
        File.expects(:executable?).with('C:\Tools\foo.exe').returns false
        File.expects(:executable?).with('\\\\remote\dir\foo.exe').returns false
        expect(subject.which('C:\Tools\foo.exe')).to be nil
        expect(subject.which('\\\\remote\dir\foo.exe')).to be nil
      end
    end

    context "and not provided with an absolute path" do
      it "should return the absolute path if found" do
        File.expects(:executable?).with('C:\Windows\system32\foo.exe').returns false
        File.expects(:executable?).with('C:\Windows\foo.exe').returns true
        File.expects(:executable?).with('C:\Windows\System32\Wbem\foo.exe').never
        expect(subject.which('foo.exe')).to eq 'C:\Windows\foo.exe'
      end

      it "should return the absolute path with file extension if found" do
        ['.COM', '.EXE', '.BAT', '.CMD', '' ].each do |ext|
          File.stubs(:executable?).with('C:\Windows\system32\foo'+ext).returns false
          File.stubs(:executable?).with('C:\Windows\System32\Wbem\foo'+ext).returns false
        end
        ['.COM', '.BAT', '.CMD', '' ].each do |ext|
          File.stubs(:executable?).with('C:\Windows\foo'+ext).returns false
        end
        File.stubs(:executable?).with('C:\Windows\foo.EXE').returns true

        expect(subject.which('foo')).to eq 'C:\Windows\foo.EXE'
      end

      it "should return nil if not found" do
        File.expects(:executable?).with('C:\Windows\system32\foo.exe').returns false
        File.expects(:executable?).with('C:\Windows\foo.exe').returns false
        File.expects(:executable?).with('C:\Windows\System32\Wbem\foo.exe').returns false
        expect(subject.which('foo.exe')).to be nil
      end
    end
  end

  describe "#expand_command" do
    it "should expand binary" do
      subject.expects(:which).with('cmd').returns 'C:\Windows\System32\cmd'
      expect(subject.expand_command(
        'cmd /c echo foo > C:\bar'
      )).to eq 'C:\Windows\System32\cmd /c echo foo > C:\bar'
    end

    it "should expand double quoted binary" do
      subject.expects(:which).with('my foo').returns 'C:\My Tools\my foo.exe'
      expect(subject.expand_command('"my foo" /a /b')).to eq '"C:\My Tools\my foo.exe" /a /b'
    end

    it "should not expand single quoted binary" do
      subject.expects(:which).with('\'C:\My').returns nil
      expect(subject.expand_command('\'C:\My Tools\foo.exe\' /a /b')).to be nil
    end

    it "should quote expanded binary if found in path with spaces" do
      subject.expects(:which).with('foo').returns 'C:\My Tools\foo.exe'
      expect(subject.expand_command('foo /a /b')).to eq '"C:\My Tools\foo.exe" /a /b'
    end

    it "should return nil if not found" do
      subject.expects(:which).with('foo').returns nil
      expect(subject.expand_command('foo /a | stuff >> NUL')).to be nil
    end
  end

  describe "#absolute_path?" do
    %w[C:/foo C:\foo \\\\Server\Foo\Bar \\\\?\C:\foo\bar //Server/Foo/Bar //?/C:/foo/bar /\?\C:/foo\bar \/Server\Foo/Bar c:/foo//bar//baz].each do |path|
      it "should return true for #{path}" do
        expect(subject).to be_absolute_path(path)
      end
    end

    %w[/ . ./foo \foo /foo /foo/../bar //foo C:foo/bar foo//bar/baz].each do |path|
      it "should return false for #{path}" do
        expect(subject).not_to be_absolute_path(path)
      end
    end
  end
end
