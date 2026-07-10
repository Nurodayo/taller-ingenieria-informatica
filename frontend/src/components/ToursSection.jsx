import { useEffect, useState } from "react";
import TourCard from "./TourCard";
import { getRecorridos } from "../../../services/api";

function ToursSection() {
  const [tours, setTours] = useState([]);
  useEffect(() => {
    getRecorridos()
      .then((data) => setTours(data))
      .catch((error) => console.error(error));
  }, []);
  const handleReserve = (tour) => {
    alert(`:0 ${tour.nombre}`);
  };
  return (
    <section className="tours-section">
      <h2>Recorridos disponibles</h2>
      <div className="tours-grid">
        {tours.map((tour) => (
          <TourCard
            key={tour.id}
            title={tour.nombre}
            from={tour.from}
            to={tour.to}
            duration={tour.hora}
            price={tour.precio}
            onReserve={() => handleReserve(tour)}
          />
        ))}
      </div>
    </section>
  );
}
export default ToursSection;
