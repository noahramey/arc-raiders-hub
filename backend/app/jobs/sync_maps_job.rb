class SyncMapsJob < ApplicationJob
  queue_as :sync

  def perform
    records = MetaForgeService.maps
    return if records.empty?

    rows = records.map do |r|
      {
        name:       r["name"].to_s,
        slug:       r["slug"].to_s,
        data:       r.except("name", "slug"),
        synced_at:  Time.current,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    MapDatum.upsert_all(rows, unique_by: :slug, update_only: %i[
      name data synced_at updated_at
    ])

    Rails.logger.info "[SyncMapsJob] Upserted #{rows.size} maps"
  end
end
