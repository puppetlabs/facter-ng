#!/bin/sh -x

cwd=$(pwd)
#sudo apt-get install make gcc ruby-dev
echo '---------------'
#sudo su
echo '---------------'

#id -a

export DEBIAN_DISABLE_RUBYGEMS_INTEGRATION=salam
export PATH=/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:/usr/local/bin:/home/runner/work/facter-ng/facter-ng/facter_3/acceptance/vendor/bundle/ruby/2.5.0/bin/:$PATH
#sudo -E sh -c 'env'

#sudo sh -c "echo 'Defaults exempt_group = docker' >> /etc/sudoers"
echo '-----------'
#sudo cat /etc/sudoers

#sudo -E sh -c 'env'

echo '\nInstall bundler'

gem install bundler
git config --global http.sslVerify false
bundle config set git.allow_insecure true

echo '\nInstall facter 3 dependencies'
cd $FACTER_3_ROOT/acceptance && bundle install

gem uninstall beaker --force
gem build $cwd/$BEAKER_ROOT/beaker.gemspec
gem install beaker-*.gem

bundle info beaker --path
echo $PATH

BP_ROOT=`bundle info beaker-puppet --path`

beaker init -h ubuntu1804-64a{hypervisor=none\,hostname=localhost} -o config/aio/options.rb
beaker provision

echo '\nStarting pre-suite'
beaker exec pre-suite --pre-suite $BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

puppet --version
#echo '\nInstall facter 4 dependencies'
#cd $cwd/$FACTER_4_ROOT && bundle install

#echo '\nConfigure facter 4 as facter 3'
#puppet config set facterng true

#gem build facter.gemspec
#gem install -f facter-*.gem

#cd $cwd/$FACTER_3_ROOT/acceptance

echo 'Running tests'
beaker exec tests
