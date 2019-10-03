LegacyFacter.add(:my_custom_fact) do
  has_weight(10000)
  setcode do
    'my_custom_fact'
  end
end
