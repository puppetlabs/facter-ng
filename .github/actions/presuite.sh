#!/bin/sh -x

export SHA=`curl --fail --silent GET --url http://builds.delivery.puppetlabs.net/passing-agent-SHAs/puppet-agent-master`
echo 'Puppet Agent SHA is' `curl --fail --silent GET --url http://builds.delivery.puppetlabs.net/passing-agent-SHAs/puppet-agent-master`

echo 'Install bundler'
gem install bundler

echo 'Install beaker'
gem install beaker

where beaker
echo $PATH
echo 'Install facter 4 dependencies'
cd $FACTER_4_ROOT && bundle install

echo 'Starting pre-suite'
bundle exec beaker exec pre-suite --pre-suite $BP_ROOT/setup/common/000-delete-puppet-when-none.rb,$BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

echo 'Configure facter 4 as facter 3'

puppet config set facterng true

gem build $FACTER_4_ROOT/facter.gemspec

ls -la

gem install -f facter-*.gem