import { useState } from "react";
import { crearReserva } from "../../../services/api";

function ReservationForm({ recorrido }) {
  const [nombre, setNombre] = useState("");
  const [correo, setCorreo] = useState("");
  const [fecha, setFecha] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const reserva = await crearReserva({
        nombre,
        correo,
        fecha,
        recorrido: recorrido.nombre,
      });
      console.log(reserva);

      alert("Reserva realizada correctamente.");
      setNombre("");
      setCorreo("");
      setFecha("");
    } catch (error) {
      console.error(error);
      alert("No se pudo crear la reserva.");
    }
  };
  return (
    <section className="reservation-section">
      <div className="reservation-card">
        <h2>Reservar recorrido</h2>
        <div className="selected-tour">
          <h3>{recorrido.nombre}</h3>
          <p>
            {recorrido.from} → {recorrido.to}
          </p>
          <p>{recorrido.hora}</p>
          <p>${recorrido.precio}</p>
        </div>
        <form className="reservation-form" onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="Tu nombre"
            value={nombre}
            onChange={(e) => setNombre(e.target.value)}
            required
          />
          <input
            type="email"
            placeholder="Correo electrónico"
            value={correo}
            onChange={(e) => setCorreo(e.target.value)}
            required
          />
          <input
            type="date"
            value={fecha}
            onChange={(e) => setFecha(e.target.value)}
            required
          />
          <button type="submit">Confirmar reserva</button>
        </form>
      </div>
    </section>
  );
}
export default ReservationForm;
