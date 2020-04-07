my_options = {
  user: 'puppetlabs',
  project: 'facter-ng',
  since_tag: File.read('VERSION').strip,
  future_release: '',
  exclude_labels: ['maintenance'],
  add_pr_wo_labels: true,
  issues: false,
  max_issues: 100,
  header: '',
  base: 'CHANGELOG.md',
  merge_prefix: '### UNCATEGORIZED PRS; GO LABEL THEM',
  configure_sections: {
    "Changed": {
      "prefix": '### Changed',
      "labels": ['backwards-incompatible']
    },
    "Added": {
      "prefix": '### Added',
      "labels": ['feature']
    },
    "Fixed": {
      "prefix": '### Fixed',
      "labels": ['bugfix']
    }
  }
}

desc 'Create changelog'
task :changelog, [:future_release] do |_, args|
  require "github_changelog_generator"

  options = GitHubChangelogGenerator::Parser.default_options

  future_release = args[:future_release]
  validate_release(future_release)
  my_options[:future_release] = future_release
  my_options.each do |k, v|
    options[k.to_sym] = v unless v.nil?
  end

  abort "user and project are required." unless options[:user] && options[:project]
  generator = GitHubChangelogGenerator::Generator.new options

  log = generator.compound_changelog

  output_filename = (options[:output]).to_s
  File.open(output_filename, "w") { |file| file.write(log) }
  puts "Done!"
  puts "Generated log placed in #{Dir.pwd}/#{output_filename}"
end

def validate_release(future_release_version)
  /[0-9]+\.[0-9]+\.[0-9]+/.match?(future_release_version) ? future_release_version : raise(ArgumentError, " The string that you entered is invalid!")
end