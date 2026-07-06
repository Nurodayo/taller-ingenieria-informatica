import Navbar from "./Navbar.jsx";

function Hero() {
  return (
    <header className="hero">
      <Navbar />

      <section className="hero-content">
        <p className="tag">Turismo gastronómico en la X Región</p>
        <h2>Recorre la Región de Los Lagos a través de sus Papa John's</h2>
        <p>
          Una experiencia ficticia de turismo urbano que conecta pizza, viaje,
          fotografía y lugares icónicos del sur de Chile.
        </p>
        <a className="button" href="#info">
          Ver más
        </a>
      </section>
    </header>
  );
}

export default Hero;
