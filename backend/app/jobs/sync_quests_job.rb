class SyncQuestsJob < ApplicationJob
  queue_as :sync

  def perform
    records = MetaForgeService.quests
    return if records.empty?

    rows = records.map do |r|
      {
        external_id:    r["id"].to_s,
        name:           r["name"].to_s,
        slug:           r["slug"].to_s,
        difficulty:     r["difficulty"],
        rewards:        r["rewards"] || {},
        required_items: r["requiredItems"] || r["required_items"] || [],
        synced_at:      Time.current,
        created_at:     Time.current,
        updated_at:     Time.current
      }
    end

    Quest.upsert_all(rows, unique_by: :external_id, update_only: %i[
      name slug difficulty rewards required_items synced_at updated_at
    ])

    Rails.logger.info "[SyncQuestsJob] Upserted #{rows.size} quests"
  end
end
