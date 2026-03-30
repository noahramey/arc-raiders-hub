import { BrowserRouter, Routes, Route, NavLink } from "react-router-dom";
import DashboardPage from "@/pages/DashboardPage";
import ItemsPage from "@/pages/ItemsPage";
import ItemDetailPage from "@/pages/ItemDetailPage";
import QuestsPage from "@/pages/QuestsPage";
import QuestDetailPage from "@/pages/QuestDetailPage";
import ArcsPage from "@/pages/ArcsPage";
import BlueprintsPage from "@/pages/BlueprintsPage";
import TradersPage from "@/pages/TradersPage";
import MapPage from "@/pages/MapPage";
import EventsPage from "@/pages/EventsPage";
import ProfilePage from "@/pages/ProfilePage";

function Nav() {
  const linkClass = ({ isActive }: { isActive: boolean }) =>
    isActive ? "font-semibold underline" : "hover:underline";

  return (
    <nav className="flex gap-4 p-4 border-b text-sm">
      <NavLink to="/" end className={linkClass}>Home</NavLink>
      <NavLink to="/items" className={linkClass}>Items</NavLink>
      <NavLink to="/quests" className={linkClass}>Quests</NavLink>
      <NavLink to="/arcs" className={linkClass}>ARCs</NavLink>
      <NavLink to="/blueprints" className={linkClass}>Blueprints</NavLink>
      <NavLink to="/traders" className={linkClass}>Traders</NavLink>
      <NavLink to="/events" className={linkClass}>Events</NavLink>
      <NavLink to="/profile" className={linkClass}>Profile</NavLink>
    </nav>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen flex flex-col">
        <Nav />
        <main className="flex-1 p-6">
          <Routes>
            <Route path="/" element={<DashboardPage />} />
            <Route path="/items" element={<ItemsPage />} />
            <Route path="/items/:slug" element={<ItemDetailPage />} />
            <Route path="/quests" element={<QuestsPage />} />
            <Route path="/quests/:slug" element={<QuestDetailPage />} />
            <Route path="/arcs" element={<ArcsPage />} />
            <Route path="/blueprints" element={<BlueprintsPage />} />
            <Route path="/traders" element={<TradersPage />} />
            <Route path="/maps/:slug" element={<MapPage />} />
            <Route path="/events" element={<EventsPage />} />
            <Route path="/profile" element={<ProfilePage />} />
          </Routes>
        </main>
        <footer className="p-4 text-center text-xs text-muted-foreground border-t">
          Game data provided by{" "}
          <a
            href="https://metaforge.app/arc-raiders"
            target="_blank"
            rel="noopener noreferrer"
            className="underline"
          >
            MetaForge
          </a>
        </footer>
      </div>
    </BrowserRouter>
  );
}
