namespace :notifications do
  desc "TODO"
  task delete_30_days_old: :environment do
    Notification.where(['created_at < ?', 30.days.ago]).where(read: true).destroy_all
  end
end
