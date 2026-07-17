import { useEffect, useState } from "react";
import mapa from "../assets/mapa.png";
import clientes from "../assets/clientes_satisfechos.png";
import { getRecorridos } from "../../../services/api";

function Home({ setView }) {
  const [recorridos, setRecorridos] = useState([]);
  const [proximoRecorrido, setProximoRecorrido] = useState(null);
  useEffect(() => {
    getRecorridos().then((data) => {
      setRecorridos(data);
      const ordenados = [...data].sort(
        (a, b) => new Date(a.hora) - new Date(b.hora),
      );
      setProximoRecorrido(ordenados[0]);
    });
  }, []);
  const formatDate = (dateString) => {
    return new Intl.DateTimeFormat("es-CL", {
      weekday: "long",
      day: "numeric",
      month: "long",
      hour: "2-digit",
      minute: "2-digit",
    }).format(new Date(dateString));
  };
  return (
    <>
      <section className="intro" id="info">
        <h2>¿Qué es PapaRuta?</h2>
        <img className="route-map" src={mapa} alt="Mapa PapaRuta" />
        <p>
          PapaRuta Los Lagos es una plataforma de turismo gastronómico
          patrocinada por Papa John's que conecta a viajeros, estudiantes y
          familias con restaurantes y sabores emblemáticos de la Región de Los
          Lagos.
        </p>
      </section>
      <section className="reservation-preview">
        <div className="reservation-content">
          <h2>¿Listo para comenzar tu aventura?</h2>
          <p>
            Reserva uno de nuestros recorridos gastronómicos y descubre la
            Región de Los Lagos acompañado por nuestros choferes certificados.
          </p>
          <div className="reservation-features">
            <div className="feature">Visita múltiples restaurantes</div>
            <div className="feature">Transporte incluido</div>
            <div className="feature">Paradas turísticas y fotográficas</div>
          </div>
          <button
            className="reservation-button"
            onClick={() => setView("tours")}
          >
            Ver recorridos y reservar
          </button>
        </div>
      </section>
      {proximoRecorrido && (
        <section className="next-tour-section">
          <h2>Próxima salida</h2>
          <div className="next-tour-card">
            <img src={proximoRecorrido.image} alt={proximoRecorrido.nombre} />
            <div className="next-tour-info">
              <h3>{proximoRecorrido.nombre}</h3>
              <p>
                {proximoRecorrido.from} → {proximoRecorrido.to}
              </p>
              <p>
                <strong>Salida:</strong> {formatDate(proximoRecorrido.hora)}
              </p>
              <p>
                <strong>Cupos:</strong> {proximoRecorrido.cupos} disponibles
              </p>
              <button onClick={() => setView("tours")}>Reservar ahora</button>
            </div>
          </div>
        </section>
      )}
      <section className="stats-section">
        <div className="stat-card">
          <h3>12+</h3>
          <p>Restaurantes asociados</p>
        </div>
        <div className="stat-card">
          <h3>{recorridos.length}</h3>
          <p>Recorridos gastronómicos</p>
        </div>
        <div className="stat-card">
          <h3>3+</h3>
          <p>Viajeros satisfechos</p>
        </div>
        <div className="stat-card">
          <h3>8</h3>
          <p>Destinos en la X Región</p>
        </div>
      </section>
      <section className="cta">
        <h2>Explora, fotografía y comparte</h2>
        <p>
          Nos complace ayudar a familias a encontrar su lugar y ser uno con la
          gastronomía.
        </p>
        <img src={clientes} alt="Clientes felices" />
      </section>
    </>
  );
}
export default Home;
