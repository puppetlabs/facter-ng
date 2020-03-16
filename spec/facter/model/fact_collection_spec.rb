# frozen_string_literal: true

describe Facter::FactCollection do
  it 'adds elements to fact collection' do
    fact_value = '1.2.3'

    fact_collection = Facter::FactCollection.new
    resolved_fact = Facter::ResolvedFact.new('os.version', fact_value)
    resolved_fact.filter_tokens = []
    resolved_fact.user_query = 'os'

    fact_collection.build_fact_collection!([resolved_fact])
    expected_hash = { 'os' => { 'version' => fact_value } }

    expect(fact_collection).to eq(expected_hash)
  end

  it 'adds elements to fact collection if fact value is nil' do
    fact_collection = Facter::FactCollection.new
    resolved_fact = Facter::ResolvedFact.new('os.version', nil)
    resolved_fact.filter_tokens = []
    resolved_fact.user_query = 'os'

    fact_collection.build_fact_collection!([resolved_fact])
    expected_hash = { 'os' => { 'version' => nil } }

    expect(fact_collection).to eq(expected_hash)
  end
end
