# frozen_string_literal: true

describe 'Facter' do
  let(:fact_name) { 'os.name' }
  let(:fact_value) { 'ubuntu' }
  let(:os_fact) { double(Facter::ResolvedFact, name: fact_name, value: fact_value, user_query: '', filter_tokens: []) }
  let(:fact_collection) { {'os' => {'name' => 'Ubuntu'}} }
  let(:empty_fact_collection) { {} }

  before do
    allow(Facter::ResolverManager).to receive(:invalidate_all_caches)
  end

  describe '#to_hash' do
    it 'returns one resolved fact' do
      allow_any_instance_of(Facter::FactManager).to receive(:resolve_facts).and_return([os_fact])
      allow_any_instance_of(Facter::FactCollection)
        .to receive(:build_fact_collection!)
        .with([os_fact])
        .and_return(fact_collection)

      resolved_facts_hash = Facter.to_hash
      expect(resolved_facts_hash).to eq(fact_collection)
    end

    it 'return no resolved facts' do
      allow_any_instance_of(Facter::FactManager).to receive(:resolve_facts).and_return([])
      allow_any_instance_of(Facter::FactCollection)
        .to receive(:build_fact_collection!)
        .with([])
        .and_return(empty_fact_collection)

      resolved_facts_hash = Facter.to_hash
      expect(resolved_facts_hash).to eq(empty_fact_collection)
    end
  end

  describe '#to_user_output' do
    it 'returns one fact' do
      user_query = 'os.name'
      options = {}
      expected_json_output = '{"os" : {"name": "ubuntu"}'

      allow_any_instance_of(Facter::FactManager).to receive(:resolve_facts).and_return([os_fact])

      json_fact_formatter = double(Facter::JsonFactFormatter)
      allow(json_fact_formatter).to receive(:format).with([os_fact]).and_return(expected_json_output)

      allow(Facter::FormatterFactory).to receive(:build).with(options).and_return(json_fact_formatter)

      formated_facts = Facter.to_user_output({}, [user_query])
      expect(formated_facts).to eq(expected_json_output)
    end

    it 'returns no facts' do
      user_query = 'os.name'
      options = {}
      expected_json_output = '{}'

      allow_any_instance_of(Facter::FactManager).to receive(:resolve_facts).and_return([])

      json_fact_formatter = double(Facter::JsonFactFormatter)
      allow(json_fact_formatter).to receive(:format).with([]).and_return(expected_json_output)

      allow(Facter::FormatterFactory).to receive(:build).with(options).and_return(json_fact_formatter)

      formatted_facts = Facter.to_user_output({}, [user_query])
      expect(formatted_facts).to eq(expected_json_output)
    end
  end

  describe '#value' do
    it 'returns a value' do
      user_query = 'os.name'

      allow_any_instance_of(Facter::FactManager).to receive(:resolve_facts).and_return([os_fact])
      allow_any_instance_of(Facter::FactCollection)
        .to receive(:build_fact_collection!)
        .with([os_fact])
        .and_return(fact_collection)

      resolved_facts_hash = Facter.value(user_query)
      expect(resolved_facts_hash).to eq('Ubuntu')
    end

    it 'return no value' do
      user_query = 'os.name'

      allow_any_instance_of(Facter::FactManager).to receive(:resolve_facts).and_return([])
      allow_any_instance_of(Facter::FactCollection)
        .to receive(:build_fact_collection!)
        .with([])
        .and_return(empty_fact_collection)

      resolved_facts_hash = Facter.value(user_query)
      expect(resolved_facts_hash).to be nil
    end
  end

  describe '#core_value' do
    it 'searched in core facts and returns a value' do
      user_query = 'os.name'

      allow_any_instance_of(Facter::FactManager).to receive(:resolve_core).and_return([os_fact])
      allow_any_instance_of(Facter::FactCollection)
        .to receive(:build_fact_collection!)
              .with([os_fact])
              .and_return(fact_collection)

      resolved_facts_hash = Facter.core_value(user_query)
      expect(resolved_facts_hash).to eq('Ubuntu')
    end

    it 'searches ion core facts and return no value' do
      user_query = 'os.name'

      allow_any_instance_of(Facter::FactManager).to receive(:resolve_core).and_return([])
      allow_any_instance_of(Facter::FactCollection)
        .to receive(:build_fact_collection!)
              .with([])
              .and_return(empty_fact_collection)

      resolved_facts_hash = Facter.core_value(user_query)
      expect(resolved_facts_hash).to be nil
    end
  end
end



describe 'facter' do
  before do
    RbConfig::CONFIG['host_os'] = 'linux'
    allow(Facter::Resolvers::OsRelease).to receive(:resolve).with(:identifier).and_return('Ubuntu')
    allow(Facter::Resolvers::OsRelease).to receive(:resolve).with(:version).and_return('18.04')
  end
  it 'returns one fact' do
    ubuntu_os_name = double(Facter::Ubuntu::OsName)
    loaded_facts = { 'os.name' => ubuntu_os_name }
    fact_name = 'os.name'
    fact_value = 'ubuntu'
    options = {}

    allow(CurrentOs.instance).to receive(:identifier).and_return('ubuntu')
    os_fact = double(Facter::ResolvedFact, name: fact_name, value: fact_value, user_query: '', filter_tokens: [])
    allow(os_fact).to receive(:value=).with('ubuntu')
    allow_any_instance_of(Facter::Ubuntu::OsName).to receive(:call_the_resolver).and_return(os_fact)

    allow_any_instance_of(Facter::FactLoader).to receive(:load_with_legacy).with(fact_value).and_return(loaded_facts)
    allow_any_instance_of(Facter::QueryParser).to receive(:parse).with([fact_name], loaded_facts)

    fact_hash = Facter::FactManager.new.resolve_facts(options, [fact_name])

    expected_resolved_fact_list = [os_fact]

    expect(fact_hash).to eq(expected_resolved_fact_list)
  end

  context '#legacy facts' do
    let(:loaded_facts) { { 'ipaddress_.*_legacy' => network_interface_class } }
    let(:network_interface_class) { Facter::Ubuntu::NetworkInterface }
    let(:options) { {} }
    let(:os_name) { 'ubuntu' }

    it 'returns one legacy fact' do
      fact_name = 'ipaddress_.*_legacy'
      user_query = 'ipaddress_ens160_legacy'
      resolved_fact_name = 'ipaddress_ens160_legacy'
      resolved_fact_value = '127.0.0.1'

      mock_os(os_name)
      mock_fact_loader_with_legacy(os_name, loaded_facts)
      mock_query_parser([user_query], loaded_facts)
      regex_resolved_fact = mock_resolved_fact(resolved_fact_name, resolved_fact_value)
      mock_fact(Facter::Ubuntu::NetworkInterface, regex_resolved_fact, fact_name)

      resolved_fact_array = Facter::FactManager.new.resolve_facts(options, [user_query])
      expected_resolved_fact_list = [regex_resolved_fact]

      expect(resolved_fact_array).to eq(expected_resolved_fact_list)
    end
  end

  it 'returns the value of the user query' do
    user_query = 'os.name'
    query_result = 'ubuntu'

    fact_base = double(Facter::FactManager)
    allow(Facter::FactManager).to receive(:new).and_return(fact_base)
    resolved_fact = double(Facter::ResolvedFact, name: 'os.name', value: 'Darwin', user_query: '', filter_tokens: [])
    resolved_fact_list = [resolved_fact]
    allow(fact_base).to receive(:resolve_facts).with({}, [user_query]).and_return(resolved_fact_list)

    fact_collection = double(Facter::FactCollection)
    allow(Facter::FactCollection).to receive(:new).and_return(fact_collection)
    allow(fact_collection).to receive(:build_fact_collection!).with(resolved_fact_list).and_return(fact_collection)
    allow(fact_collection).to receive(:dig).with('os', 'name').and_return(query_result)

    query_result = Facter.value(user_query)
    expect(query_result).to eq(query_result)
  end

  it 'return a hash with all resolved facts do' do
    fact_base = double(Facter::FactManager)
    allow(Facter::FactManager).to receive(:new).and_return(fact_base)

    resolved_fact1 =
      double(Facter::ResolvedFact, name: 'os.name', value: 'Darwin', user_query: '', filter_tokens: [])
    resolved_fact2 =
      double(Facter::ResolvedFact, name: 'os.hardware', value: 'x86_64', user_query: '', filter_tokens: [])

    resolved_fact_list = [resolved_fact1, resolved_fact2]
    allow(fact_base).to receive(:resolve_facts).and_return(resolved_fact_list)

    fact_collection = double(Facter::FactCollection)
    allow(Facter::FactCollection).to receive(:new).and_return(fact_collection)
    allow(fact_collection).to receive(:build_fact_collection!).with(resolved_fact_list).and_return(fact_collection)

    resolved_fact_collection = Facter.to_hash
    expect(resolved_fact_collection).to eq(fact_collection)
  end

  it 'returns user output' do
    options = {}
    user_query = ['os.name', 'os.hardware']

    fact_base = double(Facter::FactManager)
    allow(Facter::FactManager).to receive(:new).and_return(fact_base)

    resolved_fact1 =
      double(Facter::ResolvedFact, name: 'os.name', value: 'Darwin', user_query: '', filter_tokens: [])
    resolved_fact2 =
      double(Facter::ResolvedFact, name: 'os.hardware', value: 'x86_64', user_query: '', filter_tokens: [])

    resolved_fact_list = [resolved_fact1, resolved_fact2]
    allow(fact_base).to receive(:resolve_facts).with(options, user_query).and_return(resolved_fact_list)

    json_fact_formatter = double(Facter::JsonFactFormatter)
    allow(Facter::FormatterFactory).to receive(:build).with(options).and_return(json_fact_formatter)
    expect(json_fact_formatter).to receive(:format).and_return('json_formatter')

    user_output = Facter.to_user_output(options, *user_query)
    expect(user_output).to eq('json_formatter')
  end
end
