## Plan: Arc Raiders Tracker Hub

**What**: A full-stack tracker hub with a React frontend, Rails GraphQL API backend, and nightly background sync from the **MetaForge community API** (`metaforge.app/api/arc-raiders`) — the dominant community data source, used by most existing tracker tools.

---

### Project Layout

```
arc-raiders-hub/
├── frontend/          ← Vite + React + TypeScript
└── backend/           ← Rails 8 API mode
```

---

### Phase 1 — Rails Backend Foundation

1. `rails new backend --api --database=postgresql`
2. Add gems: `graphql`, `devise`, `devise-jwt`, `sidekiq`, `redis`, `faraday`, `rack-cors`
3. Create DB models (see schema below)
4. Build `MetaForgeService` (Faraday HTTP client wrapping `metaforge.app/api/arc-raiders`) — versioned and swappable since their API warns it can change without notice
5. Create Sidekiq jobs: `SyncItemsJob`, `SyncQuestsJob`, `SyncArcsJob`, `SyncTradersJob`, `SyncMapsJob`, `SyncEventsJob`
6. Schedule jobs nightly via `sidekiq-cron`
7. Wire GraphQL schema with `graphql-ruby` (types, queries, mutations below)
8. Connect Devise + `devise-jwt` to GraphQL `signIn`/`signUp`/`signOut` mutations

**Key database models:**

| Model | Notable columns |
|---|---|
| `users` | `email`, `username`, `jti` (JWT revocation) |
| `items` | `external_id`, `name`, `slug`, `rarity`, `category`, `item_type`, `image_url`, `meta` (jsonb), `synced_at` |
| `quests` | `external_id`, `name`, `slug`, `difficulty`, `rewards` (jsonb), `required_items` (jsonb), `synced_at` |
| `arcs` | `external_id`, `name`, `slug`, `loot` (jsonb), `synced_at` |
| `traders` | `external_id`, `name`, `inventory` (jsonb), `synced_at` |
| `map_data` | `name`, `slug`, `data` (jsonb), `synced_at` |
| `event_schedules` | `name`, `schedule` (jsonb), `synced_at` |
| `saved_builds` | `user_id`, `name`, `items` (jsonb) |
| `tracked_items` | `user_id`, `item_id`, `quantity_needed`, `quantity_current` |

> Blueprints have no dedicated MetaForge endpoint — component/crafting relationships live inside item `meta` jsonb. The blueprint tracker page surfaces this data with a user progress layer on top.

**GraphQL queries:** `items`, `item(slug)`, `quests`, `quest(slug)`, `arcs`, `arc(slug)`, `traders`, `maps`, `map(slug)`, `eventSchedules`, `currentUser`, `savedBuilds`, `trackedItems`

**GraphQL mutations:** `signUp`, `signIn`, `signOut`, `createSavedBuild`, `deleteSavedBuild`, `addTrackedItem`, `updateTrackedItem`, `removeTrackedItem`

---

### Phase 2 — React Frontend Foundation

1. `npm create vite@latest frontend -- --template react-ts`
2. Install: `tailwindcss`, `shadcn-ui`, `@apollo/client`, `graphql`, `react-router-dom`, `zustand`
3. Configure Apollo Client pointing at Rails `/graphql` endpoint with JWT auth link
4. Set up Zustand store for auth state (JWT token storage)
5. Build route tree with React Router v7

---

### Phase 3 — Core Feature Pages

Dependencies: Phase 1 + 2 must be complete

| Route | Feature |
|---|---|
| `/` | Dashboard (recent events, quick links) |
| `/items` | Item browser — filter by rarity/type/category, paginated |
| `/items/:slug` | Item detail + where to find it |
| `/quests` | Quest browser |
| `/quests/:slug` | Quest detail with required items linked to item pages |
| `/arcs` | ARCs/encounters browser with loot tables |
| `/blueprints` | Blueprint tracker — shows component tree from item meta, user can mark progress |
| `/traders` | Trader inventory with prices |
| `/maps/:slug` | Map viewer |
| `/events` | Event schedule |

---

### Phase 4 — User Features

*Depends on Phase 3*

1. `/profile` — user dashboard
2. Saved builds (create/delete via mutations, listed on profile)
3. Needed items tracker — add item + qty target, mark off as collected

---

### Phase 5 — VPS Deployment

1. Nginx as reverse proxy → Puma (port 3000) for API, serves React static build
2. Systemd services for Puma and Sidekiq
3. Redis + PostgreSQL on same server (or managed DB)
4. `.env` / Rails credentials for secrets

---

### Relevant Files to Create

- `backend/app/services/meta_forge_service.rb` — central HTTP adapter
- `backend/app/jobs/sync_*_job.rb` — one per data type
- `backend/app/graphql/arc_raiders_hub_schema.rb`
- `backend/app/graphql/types/` and `mutations/`
- `frontend/src/graphql/` — all Apollo queries, mutations, fragments
- `frontend/src/stores/auth_store.ts` — Zustand JWT store

---

### Verification

1. `rails db:migrate && rails server` — boots clean
2. Run `SyncItemsJob.perform_now` — items populate DB
3. `graphiql` or curl — `items` query returns seeded data
4. `signUp` mutation returns a valid JWT; `currentUser` query succeeds with it
5. React `npm run build` produces no errors
6. Item browser renders real data from Apollo
7. Logged-in user can create a saved build and see it persist on `/profile`

---

### Important Decisions

- **MetaForge attribution is required** — UI must include a visible link to `metaforge.app/arc-raiders`. Commercial use requires contacting them via Discord first.
- **MetaForge endpoints can break without warning** — `MetaForgeService` isolates all HTTP calls; a single file to update if endpoints change.
- **jsonb columns for external data** — avoids rigid schema churn as MetaForge adds/removes fields; parse what's needed in the service layer.
