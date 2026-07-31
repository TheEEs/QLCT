# config/initializers/auto_migrate.rb

Rails.application.config.after_initialize do
  if Rails.env.development? || Rails.env.test?
    begin
      ActiveRecord::Base.connection.migration_context.migrate
    rescue => e
      Rails.logger.warn "Auto-migration skipped or failed: #{e.message}"
    end
  end
end
