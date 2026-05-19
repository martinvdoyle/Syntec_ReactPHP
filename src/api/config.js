export const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || "https://www.luttrellstowncastlegolfmembers.com/syntec-dev/api";

export const buildApiUrl = (endpoint) => `${API_BASE_URL}/${endpoint}`;
