class SyncEventsJob < ApplicationJob
  queue_as :sync

  def perform
    records = MetaForgeService.events
    return if records.empty?

    rows = records.map do |r|
      {
        name:       r["name"].to_s,
        schedule:   r.except("name"),
        synced_at:  Time.current,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    # EventSchedules has no external_id or slug — use name as the natural key.
    EventSchedule.upsert_all(rows, unique_by: :name, update_only: %i[
      schedule synced_at updated_at
    ])

    Rails.logger.info "[SyncEventsJob] Upserted #{rows.size} event schedules"
  rescue ActiveRecord::RecordNotUnique
    # Fall back to individual upserts if name isn't unique in this batch
    records.each do |r|
      EventSchedule.find_or_initialize_by(name: r["name"].to_s).tap do |es|
        es.schedule  = r.except("name")
        es.synced_at = Time.current
        es.save!
      end
    end
  end
end
