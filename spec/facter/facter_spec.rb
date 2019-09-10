# frozen_string_literal: true

describe 'facter' do
  it 'returns one fact' do
    allow(OsDetector).to receive(:detect_family).and_return('ubuntu')

    os_fact = double(Facter::ResolvedFact, name: 'os.name', value: 'ubuntu', user_query: '', filter_tokens: [])
    allow(os_fact).to receive(:value=).with('ubuntu')
    allow_any_instance_of(Facter::Ubuntu::OsName).to receive(:call_the_resolver).and_return(os_fact)

    ubuntu_os_name = double(Facter::Ubuntu::OsName)
    allow_any_instance_of(Facter::FactLoader).to receive(:load_with_legacy).with('ubuntu').and_return({'os.name' => ubuntu_os_name})
    allow_any_instance_of(Facter::QueryParser).to receive(:parse).with(['os.name'], {'os.name' => ubuntu_os_name})

    fact_hash = Facter::Base.new.resolve_facts(['os.name'])

    expected_resolved_fact_list = [os_fact]

    expect(fact_hash).to eq(expected_resolved_fact_list)
  end
end
