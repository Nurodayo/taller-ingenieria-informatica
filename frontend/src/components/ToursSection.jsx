import { useEffect, useState } from "react";
import TourCard from "./TourCard";
import { getRecorridos } from "../../../services/api";
import ReservationForm from "./ReservationForm";
import ReservationsHistory from "./ReservationHistory";
function ToursSection() {
  const [tours, setTours] = useState([]);
  const [selectedTour, setSelectedTour] = useState(null);
  const [loading, setLoading] = useState(true);
  useEffect(() => {
    getRecorridos()
      .then((data) => setTours(data))
      .catch((error) => console.error(error))
      .finally(() => setLoading(false));
  }, []);
  const handleReserve = (tour) => {
    setSelectedTour(tour);
  };
  const [reservas, setReservas] = useState(() => {
    return JSON.parse(localStorage.getItem("reservas")) || [];
  });
  return (
    <section className="tours-section">
      <h2>Recorridos disponibles</h2>

      {loading ? (
        <div className="loading-container">
          <div className="spinner"></div>
          <p>Cargando recorridos...</p>
        </div>
      ) : (
        <div className="tours-grid">
          {tours.map((tour) => (
            <TourCard
              key={tour.id}
              title={tour.nombre}
              from={tour.from}
              to={tour.to}
              hour={tour.hora}
              price={tour.precio}
              image={tour.image}
              onReserve={() => handleReserve(tour)}
            />
          ))}
        </div>
      )}

      {selectedTour && (
        <ReservationForm
          recorrido={selectedTour}
          onClose={() => setSelectedTour(null)}
          reservas={reservas}
          setReservas={setReservas}
        />
      )}

      <ReservationsHistory reservas={reservas} />
    </section>
  );
}
export default ToursSection;
