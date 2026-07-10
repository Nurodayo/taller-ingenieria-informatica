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
              driverName={"John Papayon"}
              driverInfo={
                "Experto en rutas gastronómicas y degustación de piczas."
              }
            />
            <Drivers
              driverPhoto={chofer2}
              driverName={"Andrés Hernández"}
              driverInfo={"Ingeniero comercial"}
            />
            <Drivers
              driverPhoto={chofer3}
              driverName={"El Pibe"}
              driverInfo={"Chofer bilingüe (chino)"}
            />
            <Drivers
              driverPhoto={chofer4}
              driverName={"El Benja"}
              driverInfo={"El gran y tradicional Benja"}
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
