desc "This task is called by the Heroku scheduler add-on"

# Every day at 6am
task enqueue_digest_emails: :environment do
  Jobs::EnqueueDigestEmails.new.execute(nil)
end

# Every day at 4am
task category_stats: :environment do
  Jobs::CategoryStats.new.execute(nil)
end

# Every 15 minutes
task periodical_updates: :environment do
  Jobs::PeriodicalUpdates.new.execute(nil)
end

# Every day
task version_check: :environment do
  Jobs::VersionCheck.new.execute(nil)
end

def time
  start = Time.now
  yield
  puts "Elapsed #{((Time.now - start) * 1000).to_i}ms"
end

desc "run every task the scheduler knows about in that order, use only for debugging"
task 'scheduler:run_all' => :environment do
  MiniScheduler::Manager.discover_schedules.each do |schedule|
    puts "Running #{schedule}"
    time { schedule.new.execute({}) }
  end
end
