require "#{File.dirname(__FILE__)}/../../vendor/plugins/moonshine/lib/moonshine.rb"
class ApplicationManifest < Moonshine::Manifest::Rails

  configure({
    :hostname => "moonshine.local"
    })

  # Add your application's custom requirements here
  def application_packages
    package "libv8-dev", :ensure => :installed
    recipe :apache_server
    recipe :passenger_gem, :passenger_configure_gem_path, :passenger_apache_module, :passenger_site
    recipe :sqlite3
    recipe :rails_rake_environment, :rails_gems, :rails_directories, :rails_bootstrap, :rails_migrations, :rails_logrotate
    recipe :ntp, :time_zone, :cron_packages, :motd, :security_updates, :apt_sources, :hostname

    if precompile_asset_pipeline?
      recipe :rails_asset_pipeline
    end

    # If you've already told Moonshine about a package required by a gem with
    # :apt_gems in <tt>moonshine.yml</tt> you do not need to include it here.
    # package 'some_native_package', :ensure => :installed

    # some_rake_task = "/usr/bin/rake -f #{configuration[:deploy_to]}/current/Rakefile custom:task RAILS_ENV=#{ENV['RAILS_ENV']}"
    # cron 'custom:task', :command => some_rake_task, :user => configuration[:user], :minute => 0, :hour => 0

    # %w( root rails ).each do |user|
    #   mailalias user, :recipient => 'you@domain.com', :notify => exec('newaliases')
    # end

    # farm_config = <<-CONFIG
    #   MOOCOWS = 3
    #   HORSIES = 10
    # CONFIG
    # file '/etc/farm.conf', :ensure => :present, :content => farm_config

    # Logs for Rails, MySQL, and Apache are rotated by default
    # logrotate '/var/log/some_service.log', :options => %w(weekly missingok compress), :postrotate => '/etc/init.d/some_service restart'

    # Only run the following on the 'testing' stage using capistrano-ext's multistage functionality.
    # on_stage 'testing' do
    #   file '/etc/motd', :ensure => :file, :content => "Welcome to the TEST server!"
    # end
  end
  recipe :application_packages
end
