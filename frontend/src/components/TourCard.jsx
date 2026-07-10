function TourCard({ title, from, to, hour, price, image, onReserve }) {
  return (
    <div className="tour-card">
      <img src={image} alt={title} className="tour-image" />
      <div className="tour-content">
        <h3>{title}</h3>
        <p>
          <strong>Ruta:</strong> {from} → {to}
        </p>
        <p>
          <strong>Hora:</strong> {hour}
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
