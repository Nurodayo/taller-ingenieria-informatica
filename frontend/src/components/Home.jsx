import mapa from "../assets/mapa.png";
import clientes from "../assets/clientes_satisfechos.png";

function Home() {
  return (
    <>
      <section className="intro" id="info">
        <h2>¿Qué es PapaRuta?</h2>

        <img className="route-map" src={mapa} alt="Mapa PapaRuta" />
        <p>
          PapaRuta Los Lagos es una plataforma turística que invita a descubrir
          locales de Papa John's en la Región de Los Lagos como puntos de
          encuentro para viajeros, estudiantes y familias.
        </p>
      </section>
      <section className="places"></section>
      <section className="cta">
        <h2>Explora, fotografía y comparte</h2>
        <p>
          Nos complace ayudar a familias a encontrar su lugar y ser uno con Papa
          John's
        </p>
        <img src={clientes} alt="Clientes felices" />
      </section>
    </>
  );
}

export default Home;
