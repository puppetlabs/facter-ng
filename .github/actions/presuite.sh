#!/bin/sh -x

echo $BP_ROOT
echo $FACTER_4_ROOT

export SHA=`curl --fail --silent GET --url http://builds.delivery.puppetlabs.net/passing-agent-SHAs/puppet-agent-master`
echo 'Puppet Agent SHA is ' $SHA

echo 'Starting pre-suite'
bundle exec beaker exec pre-suite --pre-suite $BP_ROOT/setup/common/000-delete-puppet-when-none.rb,$BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

echo 'Configure facter 4 as facter 3'

puppet config set facterng true

gem build $FACTER_4_ROOT/facter.gemspec

gem install -f facter-*.gem