# frozen_string_literal: true

Facter.add('my.custom.fact') do
  has_weight(10_000)
  setcode do
    'my_custom_fact'
    # Facter.value('os')
  end
end
