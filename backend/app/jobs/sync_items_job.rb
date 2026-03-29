class SyncItemsJob < ApplicationJob
  queue_as :sync

  def perform
    records = MetaForgeService.items
    return if records.empty?

    rows = records.map do |r|
      {
        external_id: r["id"].to_s,
        name:        r["name"].to_s,
        slug:        r["slug"].to_s,
        rarity:      r["rarity"],
        category:    r["category"],
        item_type:   r["type"] || r["item_type"],
        image_url:   r["imageUrl"] || r["image_url"],
        meta:        r.except("id", "name", "slug", "rarity", "category", "type",
                               "item_type", "imageUrl", "image_url"),
        synced_at:   Time.current,
        created_at:  Time.current,
        updated_at:  Time.current
      }
    end

    Item.upsert_all(rows, unique_by: :external_id, update_only: %i[
      name slug rarity category item_type image_url meta synced_at updated_at
    ])

    Rails.logger.info "[SyncItemsJob] Upserted #{rows.size} items"
  end
end
