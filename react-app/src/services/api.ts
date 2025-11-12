import axios, { AxiosError } from 'axios'
import type { User, CreateUserInput, UpdateUserInput, ApiResponse, ApiError } from '@/types'

// Create axios instance with default config
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8080/api/v1',
  timeout: parseInt(import.meta.env.VITE_API_TIMEOUT || '30000'),
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor for adding auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('auth_token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor for handling errors
api.interceptors.response.use(
  (response) => response,
  (error: AxiosError<ApiError>) => {
    if (error.response?.status === 401) {
      // Handle unauthorized - redirect to login
      localStorage.removeItem('auth_token')
      window.location.href = '/login'
    }

    const message = error.response?.data?.error || 'An error occurred'
    return Promise.reject(new Error(message))
  }
)

// User API endpoints
export const fetchUsers = async (): Promise<User[]> => {
  const response = await api.get<ApiResponse<User[]>>('/users')
  return response.data.data
}

export const fetchUser = async (id: string): Promise<User> => {
  const response = await api.get<ApiResponse<User>>(`/users/${id}`)
  return response.data.data
}

export const createUser = async (input: CreateUserInput): Promise<User> => {
  const response = await api.post<ApiResponse<User>>('/users', input)
  return response.data.data
}

export const updateUser = async (id: string, input: UpdateUserInput): Promise<User> => {
  const response = await api.put<ApiResponse<User>>(`/users/${id}`, input)
  return response.data.data
}

export const deleteUser = async (id: string): Promise<void> => {
  await api.delete(`/users/${id}`)
}

// Export axios instance for custom requests
export default api
