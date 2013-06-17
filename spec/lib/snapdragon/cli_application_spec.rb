require_relative '../../../lib/snapdragon/cli_application'
require_relative '../../../lib/snapdragon/spec_file'
require_relative '../../../lib/snapdragon/suite'
require_relative '../../../lib/snapdragon/spec_directory'

describe Snapdragon::CliApplication do
  describe "#initialize" do
    it "stores a copy of the given command line arguments" do
      cmd_line_args = stub('command_line_args')
      cli_app = Snapdragon::CliApplication.new(cmd_line_args)
      cli_app.instance_variable_get(:@args).should eq(cmd_line_args)
    end

    it "creates an empty Suite" do
      Snapdragon::Suite.should_receive(:new)
      Snapdragon::CliApplication.new(stub)
    end

    it "assigns the new Suite to an instance variable" do
      suite = stub('suite')
      Snapdragon::Suite.stub(:new).and_return(suite)
      app = Snapdragon::CliApplication.new(stub)
      app.instance_variable_get(:@suite).should eq(suite)
    end
  end

  describe "#run" do
    let(:arguements) { stub('arguments') }
    subject { Snapdragon::CliApplication.new(arguements) }

    it "parses the given command line arguements" do
      subject.should_receive(:parse_arguements).with(arguements)
      subject.run
    end
  end

  describe "#parse_arguements" do
    let(:arguements) { ['some/path/to/some_spec.js:23', 'some/path/to/some_other_spec.js'] }
    subject { Snapdragon::CliApplication.new(arguements) }

    it "iterates over each of the arguments parsing each one" do
      subject.should_receive(:parse_arguement).with('some/path/to/some_spec.js:23')
      subject.should_receive(:parse_arguement).with('some/path/to/some_other_spec.js')
      subject.send(:parse_arguements, arguements)
    end
  end

  describe "#parse_arguement" do
    subject { Snapdragon::CliApplication.new(stub) }

    context "when the arg represents a file + line number" do
      before do
        subject.stub(:is_a_file_path_and_line_number?).and_return(true)
      end

      it "creates a SpecFile with the specified path and line number" do
        Snapdragon::SpecFile.should_receive(:new).with('some/path/to/some_spec.js', 45)
        subject.send(:parse_arguement, 'some/path/to/some_spec.js:45')
      end

      it "appends the created SpecFile to the applications Suite" do
        spec_file = stub('spec_file')
        suite = mock('suite')
        subject.instance_variable_set(:@suite, suite)
        Snapdragon::SpecFile.stub(:new).and_return(spec_file)
        suite.should_receive(:add_spec_file).with(spec_file)
        subject.send(:parse_arguement, 'some/path/to/some_spec.js:45')
      end
    end

    context "when the arg represents a file without a line number" do
      before do
        subject.stub(:is_a_file_path_and_line_number?).and_return(false)
        subject.stub(:is_a_file_path?).and_return(true)
      end

      it "creates a SpecFile object with the specified path" do
        Snapdragon::SpecFile.should_receive(:new).with('some/path/to/some_spec.js')
        subject.send(:parse_arguement, 'some/path/to/some_spec.js')
      end

      it "appends the created SpecFile to the application Suite" do
        spec_file = stub('spec_file')
        suite = mock('suite')
        subject.instance_variable_set(:@suite, suite)
        Snapdragon::SpecFile.stub(:new).and_return(spec_file)
        suite.should_receive(:add_spec_file).with(spec_file)
        subject.send(:parse_arguement, 'some/path/to/some_spec.js')
      end
    end

    context "when the arg respesents a directory" do
      before do
        subject.stub(:is_a_file_path_and_line_number?).and_return(false)
        subject.stub(:is_a_file_path?).and_return(false)
        subject.stub(:is_a_directory?).and_return(true)
      end

      it "creates a SpecDirectory with the given directory path" do
        Snapdragon::SpecDirectory.should_receive(:new).with('some/path/to/some_directory').and_return(stub(:spec_files => []))
        subject.send(:parse_arguement, 'some/path/to/some_directory')
      end

      it "gets all of the SpecFiles recursively identified in the SpecDirectory path" do
        spec_dir = mock
        Snapdragon::SpecDirectory.stub(:new).and_return(spec_dir)
        spec_dir.should_receive(:spec_files).and_return([])
        subject.send(:parse_arguement, 'some/path/to/some_directory')
      end

      it "appends the SpecFiles to the application Suite" do
        spec_dir = stub('spec_dir')
        spec_files = stub('spec_files')
        suite = mock('suite')
        subject.instance_variable_set(:@suite, suite)
        Snapdragon::SpecDirectory.stub(:new).and_return(spec_dir)
        spec_dir.stub(:spec_files).and_return(spec_files)
        suite.should_receive(:add_spec_files).with(spec_files)
        subject.send(:parse_arguement, 'some/path/to/some_directory')
      end
    end
  end
end
