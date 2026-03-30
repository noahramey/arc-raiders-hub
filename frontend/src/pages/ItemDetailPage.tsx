import { useParams } from "react-router-dom";

export default function ItemDetailPage() {
  const { slug } = useParams<{ slug: string }>();
  return <h1 className="text-2xl font-bold">Item: {slug}</h1>;
}
