#!/bin/sh -x

export DEBIAN_DISABLE_RUBYGEMS_INTEGRATION=nothing
cwd=$(pwd)

printf '\nInstall bundler\n\n'
gem install bundler

printf '\nInstall facter 3 dependencies\n\n'
cd $cwd/$FACTER_3_ROOT/acceptance && bundle install

printf '\nInstall custom beaker\n\n'
cd $cwd/$BEAKER_ROOT
gem build beaker.gemspec
gem install beaker-*.gem --bindir /bin
bundle info beaker --path

printf '\nBeaker provision\n\n'
cd $cwd/$FACTER_3_ROOT/acceptance
beaker init -h ubuntu1804-64a{hypervisor=none\,hostname=localhost} -o config/aio/options.rb
beaker provision

printf '\nBeaker pre-suite\n\n'
BP_ROOT=`bundle info beaker-puppet --path`
beaker exec pre-suite --pre-suite $BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

printf '\nConfigure facter 4 as facter 3\n\n'
puppet config set facterng true

#printf '\nInstall facter 4 dependencies\n\n'
#cd $cwd/$FACTER_4_ROOT && bundle install

#printf '\nInstall facter 4\n\n'
#gem build facter.gemspec
#gem install -f facter-*.gem

#printf '\nBeaker tests\n\n'
#cd $cwd/$FACTER_3_ROOT/acceptance
#beaker exec tests
