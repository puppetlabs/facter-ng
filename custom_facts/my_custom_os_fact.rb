
LegacyFacter.add(:os) do
  has_weight(10000)
  setcode do
    'my_custom_os'
  end
end
