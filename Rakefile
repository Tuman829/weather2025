require_relative 'config/application'

Rails.application.load_tasks

namespace :db do
  desc 'Run database migrations'
  task migrate: :environment do
    Rake::Task['db:migrate'].invoke
  end
end

namespace :weather do
  desc 'Fetch weather data'
  task fetch: :environment do
    puts 'Fetching weather data...'
    # placeholder for rake command
  end
end

namespace :cache do
  desc 'Clear weather cache'
  task clear: :environment do
    puts 'Clearing weather cache...'
    # place holder
  end
end