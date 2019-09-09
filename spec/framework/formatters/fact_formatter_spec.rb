# frozen_string_literal: true

describe 'FactFormatter' do
  it 'calls the format method on json formatter' do
    resolved_fact1 =
      double(Facter::ResolvedFact, name: 'os.name', value: 'Darwin', user_query: 'os.name', filter_tokens: [])
    resolved_fact2 =
      double(Facter::ResolvedFact, name: 'os.family', value: 'Darwin', user_query: 'os.family', filter_tokens: [])
    resolved_fact_list = [resolved_fact1, resolved_fact2]

    jsonFactFormatter = double(Facter::JsonFactFormatter)
    allow(jsonFactFormatter).to receive(:format).with(resolved_fact_list).and_return('json_value')

    json_result = Facter::FactFormater.new.format_facts(resolved_fact_list, jsonFactFormatter)
    expect(json_result).to eq('json_value')
  end
end