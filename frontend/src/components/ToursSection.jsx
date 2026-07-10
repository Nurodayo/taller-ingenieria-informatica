import TourCard from "./TourCard";
import tours from "../data/tours";

function ToursSection() {
  const handleReserve = (tour) => {
    alert(`:0 ${tour.title}`);
  };
  return (
    <section className="tours-section">
      <h2>Recorridos disponibles</h2>
      <div className="tours-grid">
        {tours.map((tour) => (
          <TourCard
            key={tour.id}
            title={tour.title}
            from={tour.from}
            to={tour.to}
            duration={tour.duration}
            price={tour.price}
            image={tour.image}
            onReserve={() => handleReserve(tour)}
          />
        ))}
      </div>
    </section>
  );
}
export default ToursSection;
