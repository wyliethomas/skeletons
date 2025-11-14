import { useState, useEffect } from 'react'
import type { LoadingState } from '@/types'

interface UseApiOptions<T> {
  immediate?: boolean
  onSuccess?: (data: T) => void
  onError?: (error: Error) => void
}

export function useApi<T>(
  apiFunction: () => Promise<T>,
  options: UseApiOptions<T> = {}
) {
  const { immediate = true, onSuccess, onError } = options

  const [data, setData] = useState<T | null>(null)
  const [error, setError] = useState<Error | null>(null)
  const [status, setStatus] = useState<LoadingState>('idle')

  const execute = async () => {
    try {
      setStatus('loading')
      setError(null)
      const result = await apiFunction()
      setData(result)
      setStatus('success')
      onSuccess?.(result)
      return result
    } catch (err) {
      const error = err instanceof Error ? err : new Error('An error occurred')
      setError(error)
      setStatus('error')
      onError?.(error)
      throw error
    }
  }

  useEffect(() => {
    if (immediate) {
      execute()
    }
  }, [])

  return {
    data,
    error,
    status,
    loading: status === 'loading',
    execute,
    reset: () => {
      setData(null)
      setError(null)
      setStatus('idle')
    },
  }
}
