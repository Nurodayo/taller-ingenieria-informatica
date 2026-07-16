const API_URL = "https://api.maidkissa.moe";
const token = "secreto";

export async function getRecorridos() {
  const response = await fetch(`${API_URL}/recorridos`, {
    headers: {
      Authorization: token,
    },
  });
  return await response.json();
}
export async function crearReserva(reserva) {
  const response = await fetch(`${API_URL}/reservas`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: token,
    },
    body: JSON.stringify(reserva),
  });

  return await response.json();
}
