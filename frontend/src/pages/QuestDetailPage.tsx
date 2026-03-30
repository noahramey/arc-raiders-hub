import { useParams } from "react-router-dom";

export default function QuestDetailPage() {
  const { slug } = useParams<{ slug: string }>();
  return <h1 className="text-2xl font-bold">Quest: {slug}</h1>;
}
