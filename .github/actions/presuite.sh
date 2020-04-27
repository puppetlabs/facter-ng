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

printf '\nInstall bundler\n'

gem install bundler
git config --global http.sslVerify false
bundle config set git.allow_insecure true

cd $cwd/$BEAKER_ROOT
gem build beaker.gemspec

printf '\nInstall facter 3 dependencies\n'
mkdir -p /opt/puppetlabs/puppet/lib/ruby/gems/2.5.0
export GEM_HOME=/opt/puppetlabs/puppet/lib/ruby/gems/2.5.0
cd $cwd/$FACTER_3_ROOT/acceptance && bundle install

gem install $cwd/$BEAKER_ROOT/beaker-*.gem --bindir /bin
bundle info beaker --path

BP_ROOT=`bundle info beaker-puppet --path`
beaker init -h ubuntu1804-64a{hypervisor=none\,hostname=localhost} -o config/aio/options.rb
beaker provision

printf '\nStarting pre-suite\n'
beaker exec pre-suite --pre-suite $BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

#echo '\nInstall facter 4 dependencies'
#cd $cwd/$FACTER_4_ROOT && bundle install

#echo '\nConfigure facter 4 as facter 3'
#puppet config set facterng true

#gem build facter.gemspec
#gem install -f facter-*.gem

#cd $cwd/$FACTER_3_ROOT/acceptance

printf '\nRunning tests\n'
beaker exec tests
