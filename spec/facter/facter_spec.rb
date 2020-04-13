# frozen_string_literal: true

describe Facter do
  let(:fact_name) { 'os.name' }
  let(:fact_value) { 'ubuntu' }
  let(:os_fact) do
    double(Facter::ResolvedFact, name: fact_name, value: fact_value, user_query: fact_name, filter_tokens: [])
  end
  let(:empty_fact_collection) { Facter::FactCollection.new }
  let(:logger) { instance_spy(Facter::Log) }
  let(:fact_manager_spy) { instance_spy(Facter::FactManager) }
  let(:fact_collection_spy) { instance_spy(Facter::FactCollection) }
  let(:key_error) { KeyError.new('key error') }

  before do
    Facter.instance_variable_set(:@logger, logger)
    Facter.clear
    allow(Facter::SessionCache).to receive(:invalidate_all_caches)
    allow(Facter::FactManager).to receive(:instance).and_return(fact_manager_spy)
    allow(Facter::FactCollection).to receive(:new).and_return(fact_collection_spy)
  end

  after do
    Facter.remove_instance_variable(:@logger)
  end

  def mock_fact_manager(method, return_value)
    allow(fact_manager_spy).to receive(method).and_return(return_value)
    allow(fact_collection_spy)
      .to receive(:build_fact_collection!)
      .with(return_value)
      .and_return(return_value.empty? ? empty_fact_collection : fact_collection_spy)
  end

  def mock_collection(method, os = nil, error = nil)
    if error
      allow(fact_collection_spy).to receive(method).with('os', 'name').and_raise(error)
    else
      allow(fact_collection_spy).to receive(method).with('os', 'name').and_return(os)
    end
  end

  describe '#to_hash' do
    it 'returns one resolved fact' do
      mock_fact_manager(:resolve_facts, [os_fact])

      expect(Facter.to_hash).to eq(fact_collection_spy)
    end

    it 'return no resolved facts' do
      mock_fact_manager(:resolve_facts, [])

      expect(Facter.to_hash).to eq(empty_fact_collection)
    end
  end

  describe '#to_user_output' do
    before do |example|
      resolved_fact = example.metadata[:resolved_fact] ? [os_fact]: []
      expected_json_output = example.metadata[:resolved_fact] ? '{"os" : {"name": "ubuntu"}': '{}'

      allow(fact_manager_spy).to receive(:resolve_facts).and_return(resolved_fact)
      json_fact_formatter = double(Facter::JsonFactFormatter)
      allow(json_fact_formatter).to receive(:format).with(resolved_fact).and_return(expected_json_output)
      allow(Facter::FormatterFactory).to receive(:build).and_return(json_fact_formatter)
    end

    it 'returns one fact and status 0', :resolved_fact => true do
      user_query = 'os.name'
      expected_json_output = '{"os" : {"name": "ubuntu"}'

      formated_facts = Facter.to_user_output({}, [user_query])

      expect(formated_facts).to eq([expected_json_output, 0])
    end

    it 'returns no facts and status 0', :resolved_fact => false do
      user_query = 'os.name'
      expected_json_output = '{}'

      formatted_facts = Facter.to_user_output({}, [user_query])

      expect(formatted_facts).to eq([expected_json_output, 0])
    end

    context 'when provided with --strict option' do
      before do
        allow(Facter::Options).to receive(:[]).with(:config)
        allow(Facter::Options.instance).to receive(:[]).with(:strict).and_return(true)
      end

      it 'returns no fact and status 1', :resolved_fact => false do
        user_query = 'os.name'
        expected_json_output = '{}'
        allow(logger).to receive(:error).with('fact "os.name" does not exist.', true)
        allow(OsDetector).to receive(:detect).and_return(:solaris)

        formatted_facts = Facter.to_user_output({}, user_query)

        expect(formatted_facts).to eq([expected_json_output, 1])
      end

      it 'returns one fact and status 0', :resolved_fact => true do
        user_query = 'os.name'
        expected_json_output = '{"os" : {"name": "ubuntu"}'

        formated_facts = Facter.to_user_output({}, user_query)

        expect(formated_facts).to eq([expected_json_output, 0])
      end
    end
  end

  describe '#value' do
    it 'returns a value' do
      mock_fact_manager(:resolve_facts, [os_fact])
      mock_collection(:value,'Ubuntu')

      expect(Facter.value('os.name')).to eq('Ubuntu')
    end

    it 'return no value' do
      mock_fact_manager(:resolve_facts, [])
      mock_collection(:value, nil)

      expect(Facter.value('os.name')).to be nil
    end
  end

  describe '#fact' do
    it 'returns a fact' do
      mock_fact_manager(:resolve_facts, [os_fact])
      mock_collection(:value,'Ubuntu')

      expect(Facter.fact('os.name')).to be_instance_of(Facter::ResolvedFact).and have_attributes(value: 'Ubuntu')
    end

    it 'can be interpolated' do
      mock_fact_manager(:resolve_facts, [os_fact])
      mock_collection(:value,'Ubuntu')

      # rubocop:disable Style/UnneededInterpolation
      expect("#{Facter.fact('os.name')}").to eq('Ubuntu')
      # rubocop:enable Style/UnneededInterpolation
    end

    it 'return no value' do
      mock_fact_manager(:resolve_facts, [])
      mock_collection(:value,nil, key_error)

      expect(Facter.fact('os.name')).to be_nil
    end
  end


  describe '#[]' do
    it 'returns a fact' do
      mock_fact_manager(:resolve_facts, [os_fact])
      mock_collection(:value,'Ubuntu')

      expect(Facter['os.name']).to be_instance_of(Facter::ResolvedFact).and(having_attributes(value: 'Ubuntu'))
    end

    it 'return no value' do
      mock_fact_manager(:resolve_facts, [])
      mock_collection(:value,nil, key_error)

      expect(Facter['os.name']).to be_nil
    end
  end

  describe '#core_value' do
    it 'searched in core facts and returns a value' do
      mock_fact_manager(:resolve_core, [os_fact])
      mock_collection(:dig,'Ubuntu')

      expect(Facter.core_value('os.name')).to eq('Ubuntu')
    end

    it 'searches ion core facts and return no value' do
      mock_fact_manager(:resolve_core, [])
      mock_collection(:dig,nil)

      expect(Facter.core_value('os.name')).to be nil
    end
  end

  describe 'LegacyFacter methods' do
    let(:legacy_facter) { class_spy(LegacyFacter)}
    before do
      allow(LegacyFacter).to receive(:clear)
      allow(LegacyFacter).to receive(:search)

    end
    describe '#clear' do
      it 'sends call to LegacyFacter' do
        Facter.clear
        expect(LegacyFacter).to have_received(:clear).once
      end
    end

    describe '#search' do
      it 'sends call to LegacyFacter' do
        dirs = ['/dir1', '/dir2']

        Facter.search(dirs)
        expect(LegacyFacter).to have_received(:search).with(dirs)
      end
    end

    describe '#search_path' do
      it 'sends call to LegacyFacter' do
        expect(LegacyFacter).to receive(:search_path).once
        Facter.search_path
      end
    end

    describe '#search_external' do
      it 'sends call to LegacyFacter' do
        dirs = ['/dir1', '/dir2']

        expect(LegacyFacter).to receive(:search_external).with(dirs)
        Facter.search_external(dirs)
      end
    end

    describe '#search_external_path' do
      it 'sends call to LegacyFacter' do
        allow(LegacyFacter).to receive(:search_external_path)
        Facter.search_external_path
        expect(LegacyFacter).to have_received(:search_external_path).once
      end
    end

    describe '#reset' do
      it 'sends call to LegacyFacter' do
        allow(LegacyFacter).to receive(:reset)

        Facter.reset

        expect(LegacyFacter).to have_received(:reset).once
      end

      it 'adds custom facts dirs' do
        allow(LegacyFacter).to receive(:search)

        Facter.reset

        expect(LegacyFacter).to have_received(:search).once
      end

      it 'add external facts dirs' do
        allow(LegacyFacter).to receive(:search_external)

        Facter.reset

        expect(LegacyFacter).to have_received(:search_external).once
      end
    end
  end

  describe '#trace?' do
    it 'returns trace variable' do
      expect(Facter).not_to be_trace
    end
  end

  describe '#trace' do
    after do
      Facter.trace(false)
    end

    it 'trace variable is true' do
      expect(Facter.trace(true)).to be_truthy
    end
  end

  describe '#debug' do
    let(:message) { 'test' }

    before do
      allow(Facter::Options.instance).to receive(:[]).with(:debug).and_return(is_debug)
    end

    context 'when log level is debug' do
      let(:is_debug) { true }

      it 'logs a debug message' do
        allow(logger).to receive(:debug).with('test')

        expect(Facter.debug(message)).to be(nil)
      end
    end

    context 'when log level is not debug' do
      let(:is_debug) { false }

      it "doesn't log anything" do
        Facter.debug(message)

        expect(logger).not_to have_received(:debug).with(message)
      end
    end
  end

  describe '#debugging' do
    let(:priority_options) { {} }

    before do
      allow(Facter::Options.instance).to receive(:priority_options).and_return(priority_options)
    end

    it 'sets log level to debug' do
      expect(priority_options).to receive(:[]=).with(:debug, true)
      Facter.debugging(true)
    end
  end

  describe '#debugging?' do
    it 'returns that log_level is not debug' do
      expect(Facter::Options.instance).to receive(:[]).with(:debug).and_return(false)
      Facter.debugging?
    end
  end

  describe '#log_exception' do
    context 'when trace options is true' do
      before do
        Facter.trace(true)
      end

      after do
        Facter.trace(false)
      end

      let(:message) { 'Some error message' }
      let(:exception) { FlushFakeError.new }
      let(:expected_message) { "Some error message\nbacktrace:\nprog.rb:2:in `a'" }

      it 'format exception to display backtrace' do
        exception.set_backtrace("prog.rb:2:in `a'")

        Facter.log_exception(exception, message)

        expect(logger).to have_received(:error).with(expected_message)
      end
    end
  end
end
