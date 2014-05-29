require 'travis'
require 'travis/pro'

class TravisciJob < Dashing::Job

  protected

  def do_execute
    config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/travisci.yml'
    config = YAML::load(File.open(config_file))

    config.each do |type, type_config|
      unless type_config["repositories"].nil?
        type_config["repositories"].each do |data_id, repo|
          send_event(data_id, update_builds(repo, type_config))
        end
      else
        puts "No repositories for travis.#{type}"
      end
    end
  end

  def update_builds(repository, config)
    builds = []
    repo = nil

    if config["type"] == "pro"
      Travis::Pro.access_token = config["auth_token"]
      repo = Travis::Pro::Repository.find(repository)
    else  # Standard namespace
      Travis.access_token = config["auth_token"]
      repo = Travis::Repository.find(repository)
    end

    builds = repo.recent_builds.first(5).map do |build|
      result = {
        success:   build.state,
        duration:  build.duration,
        change_author: build.commit.author_email,
        timestamp: (build.finished_at || build.started_at).to_i
      }

      result
    end

    timestamp = builds.empty? ? nil : builds[0][:timestamp]

    { builds: builds, timestamp: timestamp }
  end
end

#job = TravisciJob.new 'travisci', {}
#SCHEDULER.every('2m', first_in: '1s') {
#  job.execute
#}
#
