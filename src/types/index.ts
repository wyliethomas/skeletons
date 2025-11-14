// User types
export interface User {
  id: string
  email: string
  name: string
  created_at?: string
  updated_at?: string
}

export interface CreateUserInput {
  email: string
  name: string
}

export interface UpdateUserInput {
  email?: string
  name?: string
}

// API response types
export interface ApiResponse<T> {
  data: T
  meta?: {
    total?: number
    page?: number
    per_page?: number
  }
}

export interface ApiError {
  error: string
  details?: string[]
}

// Common types
export type LoadingState = 'idle' | 'loading' | 'success' | 'error'
