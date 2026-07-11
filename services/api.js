const API_URL = "https://api.maidkissa.moe";

export async function getRecorridos() {
  const response = await fetch(`${API_URL}/recorridos`);
  return await response.json();
}
export async function crearReserva(reserva) {
  const response = await fetch(`${API_URL}/reservas`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(reserva),
  });

  return await response.json();
}
