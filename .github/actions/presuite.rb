ENV['DEBIAN_DISABLE_RUBYGEMS_INTEGRATION']='no_wornings'
ENV['PATH']='/opt/puppetlabs/bin/:/opt/puppetlabs/puppet/bin:' + ENV['PATH']

Open3.capture2('gem install bundle')

