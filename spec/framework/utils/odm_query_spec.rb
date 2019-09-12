# frozen_string_literal: true

describe 'ODMQuery' do
  let(:odm_query) { Facter::ODMQuery.new }

  it 'creates a query' do
    odm_query.equals('name', '12345')

    expect(Open3).to receive(:capture2).with("odmget -q 'name' = '12345' CuDv")
    odm_query.execute
  end

  it 'can chain conditions' do
    odm_query.equals('field1', 'value').like('field2', 'value*')

    expect(Open3).to receive(:capture2)
      .with("odmget -q 'field1' = 'value' AND 'field2' like 'value*' CuDv")
    odm_query.execute
  end
end
