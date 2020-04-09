# frozen_string_literal: true

describe Facter::FactCollection do
  subject(:fact_collection) { Facter::FactCollection.new }

  describe '#build_fact_collection!' do
    context 'when fact has some value' do
      let(:fact_value) { '1.2.3' }
      let(:resolved_fact) { Facter::ResolvedFact.new('os.version', fact_value, :core) }

      before do
        resolved_fact.filter_tokens = []
        resolved_fact.user_query = 'os'
      end

      it 'adds fact to collection' do
        fact_collection.build_fact_collection!([resolved_fact])
        expected_hash = { 'os' => { 'version' => fact_value } }

        expect(fact_collection).to eq(expected_hash)
      end
    end

    context 'when fact value is nil' do
      context 'when fact type is legacy' do
        let(:resolved_fact) { Facter::ResolvedFact.new('os.version', nil, :legacy) }

        before do
          resolved_fact.filter_tokens = []
          resolved_fact.user_query = 'os'
        end

        it 'does not add fact to collection' do
          fact_collection.build_fact_collection!([resolved_fact])
          expected_hash = {}

          expect(fact_collection).to eq(expected_hash)
        end
      end

      context 'when fact type is core' do
        let(:resolved_fact) { Facter::ResolvedFact.new('os.version', nil, :core) }

        before do
          resolved_fact.filter_tokens = []
          resolved_fact.user_query = 'os'
        end

        it 'does not add fact to collection' do
          fact_collection.build_fact_collection!([resolved_fact])
          expected_hash = {}

          expect(fact_collection).to eq(expected_hash)
        end
      end

      context 'when fact type is :custom' do
        let(:resolved_fact) { Facter::ResolvedFact.new('os.version', nil, :custom) }

        before do
          resolved_fact.filter_tokens = []
          resolved_fact.user_query = 'operatingsystem'
        end

        it 'adds fact to collection' do
          fact_collection.build_fact_collection!([resolved_fact])
          expected_hash = { 'os' => { 'version' => nil } }

          expect(fact_collection).to eq(expected_hash)
        end
      end
    end
  end
end
