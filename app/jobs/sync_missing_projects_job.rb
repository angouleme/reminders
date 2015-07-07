class SyncMissingProjectsJob
  attr_reader :slack_channels_repository,
              :projects_repository,
              :reminders_repository

  def initialize(projects_repository:, slack_repository:, reminders_repository:)
    @projects_repository = projects_repository
    @slack_channels_repository = slack_repository
    @reminders_repository = reminders_repository
  end

  def perform
    return unless AppConfig.slack_enabled
    sync_projects
    sync_with_reminders
  end

  private

  def sync_projects
    Projects::SyncWithSlackChannels
      .new(projects_repository, slack_channels_repository)
      .call
  end

  def sync_with_reminders
    reminders_repository.all.each do |reminder|
      Reminders::SyncProjects.new(reminder).call
    end
  end
end
