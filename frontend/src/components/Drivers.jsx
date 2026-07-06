function Drivers({ driverPhoto, driverName, driverInfo }) {
  return (
    <div className="driver-card">
      <img src={driverPhoto} alt="Cristofer-chofer-todopoderoso" />
      <div>
        <h3>{driverName}</h3>
        <p>{driverInfo}</p>
      </div>
    </div>
  );
}

export default Drivers;
