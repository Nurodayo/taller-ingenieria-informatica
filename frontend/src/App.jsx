import { useState } from "react";
import Navbar from "./components/Navbar.jsx";
import Hero from "./components/Hero.jsx";
import ViewToggle from "./components/ViewToggle.jsx";
import Home from "./components/Home.jsx";
import Drivers from "./components/Drivers.jsx";
import About from "./components/About.jsx";
import Footer from "./components/Footer.jsx";
import "./App.css";

function App() {
  const [view, setView] = useState("home");

  return (
    <>
      <Hero />
      <main>
        <ViewToggle view={view} setView={setView} />
        {view === "home" && <Home />}
        {view === "drivers" && (
          <section className="page-view">
            <h2>Información de choferes</h2>
            <p>
              Nuestros choferes son los encargados de conectar cada punto de la
              PapaRuta Los Lagos.
            </p>
            <Drivers />
            <Drivers />
            <Drivers />
            <Drivers />
          </section>
        )}
        {view === "about" && <About />}
      </main>
      <Footer />
    </>
  );
}

export default App;
