import chofer from "../assets/cristochofer.jpg";

function Drivers() {
  return (
    <div className="driver-card">
      <img src={chofer} alt="Cristofer-chofer-todopoderoso" />
      <div>
        <h3>John Papayón</h3>
        <p>
          Chofer oficial de PapaRuta Los Lagos. Experto en rutas gastronómicas y
          degustación de piczas.
        </p>
      </div>
    </div>
  );
}

export default Drivers;
