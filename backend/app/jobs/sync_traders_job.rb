class SyncTradersJob < ApplicationJob
  queue_as :sync

  def perform
    records = MetaForgeService.traders
    return if records.empty?

    rows = records.map do |r|
      {
        external_id: r["id"].to_s,
        name:        r["name"].to_s,
        inventory:   r["inventory"] || [],
        synced_at:   Time.current,
        created_at:  Time.current,
        updated_at:  Time.current
      }
    end

    Trader.upsert_all(rows, unique_by: :external_id, update_only: %i[
      name inventory synced_at updated_at
    ])

    Rails.logger.info "[SyncTradersJob] Upserted #{rows.size} traders"
  end
end
