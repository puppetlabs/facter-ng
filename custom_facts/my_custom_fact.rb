# frozen_string_literal: true

Facter.value("operatingsystem")
Facter.add("operatingsystem", :weight => 999) { setcode { "salam" } }
Facter.value("operatingsystem")
