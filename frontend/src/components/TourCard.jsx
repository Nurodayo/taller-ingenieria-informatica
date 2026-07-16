function TourCard({ title, from, to, hour, price, image, seats, onReserve }) {
  const formatDate = (hour) => {
    const date = new Date(hour);

    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const year = date.getFullYear();

    const hours = String(date.getHours()).padStart(2, "0");
    const minutes = String(date.getMinutes()).padStart(2, "0");

    return `${day}/${month}/${year} - ${hours}:${minutes}`;
  };

  return (
    <div className="tour-card">
      <img src={image} alt={title} className="tour-image" />
      <div className="tour-content">
        <h3>{title}</h3>
        <p>
          <strong>Ruta:</strong> {from} → {to}
        </p>
        <p>
          <strong>Fecha:</strong> {formatDate(hour)}
        </p>
        <p>
          <strong>Cupos:</strong> {seats}
        </p>
        <p className="tour-price">${price.toLocaleString("es-CL")}</p>
        <button className="reserve-button" onClick={onReserve}>
          Reservar recorrido
        </button>
      </div>
    </div>
  );
}
export default TourCard;
