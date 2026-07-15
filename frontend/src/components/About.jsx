import bus from "../assets/bus_hell.png";

function About() {
  return (
    <section className="page-view about-page">
      <h2>Acerca de PapaRuta Los Lagos</h2>

      <div className="about-card">
        <img src={bus} alt="Bus a Alerce" className="about-image" />

        <div className="about-content">
          <h3>De una pizza a toda una región</h3>
          <p>
            PapaRuta Los Lagos nació como una plataforma de turismo gastronómico
            centrada en los locales de Papa John's de la Región de Los Lagos.
          </p>
          <p>
            Hoy el proyecto ha evolucionado hacia una experiencia más amplia,
            incorporando restaurantes y recorridos gastronómicos por distintos
            destinos de la X Región.
          </p>
          <p className="about-highlight">
            Descubre sabores, rutas y experiencias del sur de Chile.
          </p>
        </div>
      </div>
    </section>
  );
}
export default About;
