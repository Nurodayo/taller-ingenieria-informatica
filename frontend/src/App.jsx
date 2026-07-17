import { useState } from "react";
import Navbar from "./components/Navbar.jsx";
import Hero from "./components/Hero.jsx";
import ViewToggle from "./components/ViewToggle.jsx";
import Home from "./components/Home.jsx";
import Drivers from "./components/Drivers.jsx";
import About from "./components/About.jsx";
import Footer from "./components/Footer.jsx";
import chofer1 from "./assets/cristochofer.jpg";
import chofer2 from "./assets/andresfeliz.png";
import chofer3 from "./assets/pibechofertraductorchino.png";
import chofer4 from "./assets/pibexbenja.png";
import ToursSection from "./components/ToursSection.jsx";
import "./App.css";

function App() {
  const [view, setView] = useState("home");

  return (
    <>
      <Hero />
      <main>
        <ViewToggle view={view} setView={setView} />
        {view === "home" && <Home setView={setView} />}
        {view === "tours" && <ToursSection />}
        {view === "drivers" && (
          <section className="page-view">
            <h2>Información de choferes</h2>
            <p>
              Nuestros choferes son los encargados de conectar cada punto de la
              PapaRuta Los Lagos.
            </p>
            <Drivers
              driverPhoto={chofer1}
              driverName={"Cristofer Leiva (克里斯托费尔·维科)"}
              driverInfo={
                "Experto en cultura china y degustación de piczas. Hincha de Colo-Colo."
              }
            />
            <Drivers
              driverPhoto={chofer2}
              driverName={"Andrés Hernández"}
              driverInfo={
                "Ingeniero comercial. El ser humano más feliz que el mundo ha conocido."
              }
            />
            <Drivers
              driverPhoto={chofer3}
              driverName={"Pibe"}
              driverInfo={"Chofer bilingüe (chino mandarín y argentino)"}
            />
            <Drivers
              driverPhoto={chofer4}
              driverName={"El Benja"}
              driverInfo={
                "El gran Benja. Experto en Puerto Montt y en salmones."
              }
            />
          </section>
        )}
        {view === "about" && <About />}
      </main>
      <Footer />
    </>
  );
}

export default App;
