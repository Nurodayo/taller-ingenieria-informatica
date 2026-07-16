function ReservationsHistory({ reservas }) {
  if (reservas.length === 0) {
    return (
      <section className="history-section">
        <h2>Tus reservas</h2>
        <p>Aún no has realizado reservas.</p>
      </section>
    );
  }

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
    <section className="history-section">
      <h2>Tus reservas</h2>
      <div className="history-grid">
        {reservas.map((reserva) => (
          <div className="history-card" key={reserva.id}>
            <h3>{reserva.recorrido}</h3>
            <p>
              <strong>Nombre:</strong> {reserva.nombre}
            </p>
            <p>
              <strong>Fecha:</strong> {reserva.fecha}
            </p>
            <p>
              {reserva.from} → {reserva.to}
            </p>
            <p>{formatDate(reserva.hora)}</p>
          </div>
        ))}
      </div>
    </section>
  );
}
export default ReservationsHistory;
