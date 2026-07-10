import { useEffect, useState } from "react";

function ReservationsHistory() {
  const [reservas, setReservas] = useState([]);
  useEffect(() => {
    const historial = JSON.parse(localStorage.getItem("reservas")) || [];
    setReservas(historial);
  }, []);
  if (reservas.length === 0) {
    return (
      <section className="history-section">
        <h2>Tus reservas</h2>
        <p>Aún no has realizado reservas.</p>
      </section>
    );
  }
  return (
    <section className="history-section">
      <h2>Tus reservas</h2>
      <div className="history-grid">
        {reservas.map((reserva, index) => (
          <div className="history-card" key={index}>
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
            <p>{reserva.hora}</p>
          </div>
        ))}
      </div>
    </section>
  );
}
export default ReservationsHistory;
