#!/bin/sh -x

export DEBIAN_DISABLE_RUBYGEMS_INTEGRATION=nothing
cwd=$(pwd)

printf '\nInstall bundler\n'
gem install bundler

cd $cwd/$BEAKER_ROOT
gem build beaker.gemspec

printf '\nInstall facter 3 dependencies\n'
cd $cwd/$FACTER_3_ROOT/acceptance && bundle install

printf '\nInstall custom beaker\n'
gem install $cwd/$BEAKER_ROOT/beaker-*.gem --bindir /bin
bundle info beaker --path


printf '\nBeaker provision\n'
beaker init -h ubuntu1804-64a{hypervisor=none\,hostname=localhost} -o config/aio/options.rb
beaker provision

printf '\nBeaker pre-suite\n'
BP_ROOT=`bundle info beaker-puppet --path`
beaker exec pre-suite --pre-suite $BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

printf '\nConfigure facter 4 as facter 3'
puppet config set facterng true

printf '\nInstall facter 4 dependencies'
cd $cwd/$FACTER_4_ROOT && bundle install

gem build facter.gemspec
gem install -f facter-*.gem

cd $cwd/$FACTER_3_ROOT/acceptance

printf '\nBeaker tests\n'
beaker exec tests
