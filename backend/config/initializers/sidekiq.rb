Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }

  config.on(:startup) do
    schedule = {
      "sync_items" => {
        "cron"  => "0 3 * * *",   # 03:00 UTC nightly
        "class" => "SyncItemsJob",
        "queue" => "sync"
      },
      "sync_quests" => {
        "cron"  => "5 3 * * *",
        "class" => "SyncQuestsJob",
        "queue" => "sync"
      },
      "sync_arcs" => {
        "cron"  => "10 3 * * *",
        "class" => "SyncArcsJob",
        "queue" => "sync"
      },
      "sync_traders" => {
        "cron"  => "15 3 * * *",
        "class" => "SyncTradersJob",
        "queue" => "sync"
      },
      "sync_maps" => {
        "cron"  => "20 3 * * *",
        "class" => "SyncMapsJob",
        "queue" => "sync"
      },
      "sync_events" => {
        "cron"  => "25 3 * * *",
        "class" => "SyncEventsJob",
        "queue" => "sync"
      }
    }

    Sidekiq::Cron::Job.load_from_hash(schedule)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
end
