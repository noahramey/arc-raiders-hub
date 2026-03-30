import { useParams } from "react-router-dom";

export default function MapPage() {
  const { slug } = useParams<{ slug: string }>();
  return <h1 className="text-2xl font-bold">Map: {slug}</h1>;
}
