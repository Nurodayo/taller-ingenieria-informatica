import { useState } from "react";
import { crearReserva, getRecorridos } from "../../../services/api";

function ReservationForm({
  recorrido,
  onClose,
  reservas,
  setReservas,
  setTours,
}) {
  const [nombre, setNombre] = useState("");
  const [correo, setCorreo] = useState("");
  // const [fecha, setFecha] = useState("");

  const formatDate = (hour) => {
    const date = new Date(hour);

    const day = String(date.getDate()).padStart(2, "0");
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const year = date.getFullYear();

    const hours = String(date.getHours()).padStart(2, "0");
    const minutes = String(date.getMinutes()).padStart(2, "0");

    return `${day}/${month}/${year} - ${hours}:${minutes}`;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const hoy = new Date();

      const fechaActual = `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, "0")}-${String(hoy.getDate()).padStart(2, "0")}`;

      const reservaCreada = await crearReserva({
        nombre,
        correo,
        fecha: fechaActual,
        asientos: 1,
        recorrido: recorrido.id,
      });
      const nuevaReserva = {
        id: reservaCreada.id,
        nombre,
        correo,
        fecha: fechaActual,
        recorrido: recorrido.nombre,
        from: recorrido.from,
        to: recorrido.to,
        hora: recorrido.hora,
      };
      const nuevoHistorial = [...reservas, nuevaReserva];
      setReservas(nuevoHistorial);
      localStorage.setItem("reservas", JSON.stringify(nuevoHistorial));
      const recorridosActualizados = await getRecorridos();
      setTours(recorridosActualizados);
      alert("Reserva realizada correctamente.");
      setNombre("");
      setCorreo("");
      onClose();
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
          <p>{formatDate(recorrido.hora)}</p>
          <p>${recorrido.precio}</p>
        </div>
        <form className="reservation-form" onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="Nombre"
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
          <button type="submit">Confirmar reserva</button>
        </form>
      </div>
    </section>
  );
}
export default ReservationForm;
