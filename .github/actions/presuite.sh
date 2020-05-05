#!/bin/sh -x

export DEBIAN_DISABLE_RUBYGEMS_INTEGRATION=no_wornings
cwd=$(pwd)

#printf '\nInstall bundler\n\n'
#gem install bundler

#printf '\nInstall facter 4 dependencies\n\n'
#cd $cwd/$FACTER_4_ROOT && bundle install

printf '\nInstall facter 3 acceptance dependencies\n\n'
cd $cwd/$FACTER_3_ROOT/acceptance && bundle install
export PATH=/opt/puppetlabs/bin/:/opt/puppetlabs/puppet/bin:$PATH

printf '\nInstall custom beaker\n\n'
cd $cwd/$BEAKER_ROOT
gem build beaker.gemspec
gem install beaker-*.gem --bindir /bin

printf '\nBeaker provision\n\n'
cd $cwd/$FACTER_3_ROOT/acceptance
beaker init -h ubuntu1804-64a{hypervisor=none\,hostname=localhost} -o config/aio/options.rb
beaker provision

printf '\nBeaker pre-suite\n\n'
BP_ROOT=`bundle info beaker-puppet --path`
beaker exec pre-suite --pre-suite $BP_ROOT/setup/aio/010_Install_Puppet_Agent.rb

printf '\nConfigure facter 4 as facter 3\n\n'
puppet config set facterng true

agent_facter_ng_version=`facter-ng --version | tr -d '\r'`

cd $cwd/$FACTER_4_ROOT
/opt/puppetlabs/puppet/bin/gem build agent/facter-ng.gemspec
/opt/puppetlabs/puppet/bin/gem uninstall facter-ng
/opt/puppetlabs/puppet/bin/gem install -f facter-ng-*.gem

cd /opt/puppetlabs/puppet/bin
mv facter-ng facter

#rm -rf /opt/puppetlabs/puppet/lib/ruby/gems/2.5.0/gems/facter-ng-$agent_facter_ng_version/*
#cp -r $cwd/$FACTER_4_ROOT/* /opt/puppetlabs/puppet/lib/ruby/gems/2.5.0/gems/facter-ng-$agent_facter_ng_version/
#cp /opt/puppetlabs/puppet/bin/facter-ng /opt/puppetlabs/bin/
#mv /opt/puppetlabs/bin/facter-ng /opt/puppetlabs/bin/facter

facter -v
puppet facts | grep facterversion

#printf '\nBeaker tests\n\n'
#cd $cwd/$FACTER_3_ROOT/acceptance
#beaker exec tests --test-tag-exclude=server,facter_3 --test-tag-or=risk:high,audit:high 2>&1 | tee results.txt
#sed -n '/Failed Tests Cases:/,/Skipped Tests Cases:/p' results.txt | grep 'Test Case' | awk {'print $3'}
