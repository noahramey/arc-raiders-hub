class SyncArcsJob < ApplicationJob
  queue_as :sync

  def perform
    records = MetaForgeService.arcs
    return if records.empty?

    rows = records.map do |r|
      {
        external_id: r["id"].to_s,
        name:        r["name"].to_s,
        slug:        r["slug"].to_s,
        loot:        r["loot"] || [],
        synced_at:   Time.current,
        created_at:  Time.current,
        updated_at:  Time.current
      }
    end

    Arc.upsert_all(rows, unique_by: :external_id, update_only: %i[
      name slug loot synced_at updated_at
    ])

    Rails.logger.info "[SyncArcsJob] Upserted #{rows.size} arcs"
  end
end
