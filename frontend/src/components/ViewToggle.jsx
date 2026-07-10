function ViewToggle({ view, setView }) {
  return (
    <div className="view-toggle">
      <button
        className={`view-btn ${view === "home" ? "active" : ""}`}
        onClick={() => setView("home")}
      >
        Inicio
      </button>
      <button
        className={`view-btn ${view === "tours" ? "active" : ""}`}
        onClick={() => setView("tours")}
      >
        Recorridos
      </button>
      <button
        className={`view-btn ${view === "drivers" ? "active" : ""}`}
        onClick={() => setView("drivers")}
      >
        Choferes
      </button>
      <button
        className={`view-btn ${view === "about" ? "active" : ""}`}
        onClick={() => setView("about")}
      >
        Acerca de
      </button>
    </div>
  );
}
export default ViewToggle;
