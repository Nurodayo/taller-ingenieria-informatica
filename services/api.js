const API_URL = "https://s8f4o47d7l.execute-api.us-east-1.amazonaws.com";

export async function getRecorridos() {
  const response = await fetch(`${API_URL}/recorridos`);
  return await response.json();
}
