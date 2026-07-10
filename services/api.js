const API_URL = "https://s8f4o47d7l.execute-api.us-east-1.amazonaws.com";

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
