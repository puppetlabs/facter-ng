#!/bin/sh -x

cwd=$(pwd)
#apt-get install make gcc ruby-dev
echo '---------------'
config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
sudo su -
echo '---------------'

apt install vim

echo '\nInstall bundler'
sudo gem install bundler

echo '\nInstall facter 3 dependencies'
sudo cd $FACTER_3_ROOT/acceptance && bundle install

BP_ROOT=`§bundle info beaker-puppet --path`
echo $BP_ROOT

sudo bundle exec beaker init -h ubuntu1804-64a{hypervisor=none\,hostname=localhost} -o config/aio/options.rb
sudo bundle exec beaker provision

echo '\nStarting pre-suite'
sudo bundle exec beaker exec pre-suite --pre-suite $BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

#echo '\nInstall facter 4 dependencies'
#cd $cwd/$FACTER_4_ROOT && bundle install

#echo '\nConfigure facter 4 as facter 3'
#puppet config set facterng true

#gem build facter.gemspec
#gem install -f facter-*.gem

#cd $cwd/$FACTER_3_ROOT/acceptance
sudo bundle exec beaker exec tests