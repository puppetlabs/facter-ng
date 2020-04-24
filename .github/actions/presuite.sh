#!/bin/sh -x

cwd=$(pwd)
#apt-get install make gcc ruby-dev
echo '---------------'
#sudo su -
echo '---------------'

#id -a


export PATH=/opt/puppetlabs/puppet/bin:$PATH

sudo -E sh -c 'env'

sudo sh -c "echo 'Defaults exempt_group = docker' >> /etc/sudoers"
echo '-----------'
sudo cat /etc/sudoers

sudo -E sh -c 'env'

echo '\nInstall bundler'
gem install bundler

echo '\nInstall facter 3 dependencies'
cd $FACTER_3_ROOT/acceptance && bundle install

BP_ROOT=`bundle info beaker-puppet --path`
echo $BP_ROOT

bundle exec beaker init -h ubuntu1804-64a{hypervisor=none\,hostname=localhost} -o config/aio/options.rb
bundle exec beaker provision

echo '\nStarting pre-suite'
bundle exec beaker exec pre-suite --pre-suite $BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

#echo '\nInstall facter 4 dependencies'
#cd $cwd/$FACTER_4_ROOT && bundle install

#echo '\nConfigure facter 4 as facter 3'
#puppet config set facterng true

#gem build facter.gemspec
#gem install -f facter-*.gem

#cd $cwd/$FACTER_3_ROOT/acceptance
bundle exec beaker exec tests