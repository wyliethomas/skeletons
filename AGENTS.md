# AGENTS.md - React Application Architecture

> This file provides context for AI coding assistants. It follows the AGENTS.md standard
> and works with Claude Code, GitHub Copilot, Cursor, and other AI development tools.

This document explains the architecture, patterns, and conventions used in this React application. Use this as a guide when extending or modifying the codebase.

## Quick Start Commands

```bash
# Setup
./setup.sh                   # Complete Docker setup

# Development
docker compose up            # Start development server
docker compose down          # Stop development server
npm run dev                  # Run dev server (local, outside Docker)

# Dependencies
docker compose run --rm web npm install
npm install                  # Install locally

# Building
docker compose run --rm web npm run build
npm run build               # Build for production

# Testing
docker compose run --rm web npm test
docker compose run --rm web npm run test:coverage
npm test                    # Run tests locally

# Linting
docker compose run --rm web npm run lint
docker compose run --rm web npm run lint:fix
npm run lint                # Lint locally

# Type Checking
docker compose run --rm web npm run type-check
npm run type-check          # Check TypeScript types
```

## Architecture Overview

This is a **React 18 SPA** (Single Page Application) following these principles:

1. **Component-Based Architecture** - UI built from reusable components
2. **Type Safety** - TypeScript for all code
3. **Declarative Routing** - React Router for navigation
4. **Utility-First Styling** - Tailwind CSS for rapid UI development
5. **Service Layer Pattern** - API logic separated from components
6. **Custom Hooks** - Reusable stateful logic

## Technology Stack

- **React 18** - UI library with concurrent features
- **TypeScript** - Static typing
- **Vite** - Build tool (faster than webpack)
- **React Router v6** - Client-side routing
- **Tailwind CSS** - Utility-first CSS
- **Axios** - HTTP client
- **Vitest** - Testing framework

## Project Structure Philosophy

```
src/
├── components/     # Reusable UI components (presentational)
├── pages/          # Page-level components (route destinations)
├── hooks/          # Custom React hooks (reusable logic)
├── services/       # API and external services
├── types/          # TypeScript type definitions
├── utils/          # Pure utility functions
```

### Why This Structure?

- **components/** - Reusable across multiple pages
- **pages/** - One component per route, compose from components
- **hooks/** - Extract and reuse stateful logic
- **services/** - Keep API logic separate from UI
- **types/** - Centralized type definitions
- **utils/** - Pure functions, no side effects

## Component Patterns

### 1. Page Components

**Location:** `src/pages/`

**Responsibility:**
- Represent a route/page
- Fetch data
- Compose smaller components
- Handle page-level state

**Example:**
```tsx
// src/pages/Users.tsx
export default function Users() {
  const { data, loading } = useApi(fetchUsers)

  if (loading) return <Loading />

  return (
    <div>
      <PageHeader title="Users" />
      <UserList users={data} />
    </div>
  )
}
```

### 2. Reusable Components

**Location:** `src/components/`

**Responsibility:**
- UI presentation
- Reusable across pages
- Accept props, minimal state
- Composable

**Example:**
```tsx
// src/components/Button.tsx
interface ButtonProps {
  variant?: 'primary' | 'secondary'
  onClick?: () => void
  children: React.ReactNode
}

export default function Button({ variant = 'primary', onClick, children }: ButtonProps) {
  const className = variant === 'primary' ? 'btn-primary' : 'btn-secondary'
  return (
    <button className={className} onClick={onClick}>
      {children}
    </button>
  )
}
```

### 3. Layout Components

**Location:** `src/components/Layout.tsx`

**Responsibility:**
- Page structure (header, nav, footer)
- Wraps all pages using `<Outlet />`
- Shared navigation

**Pattern:**
```tsx
export default function Layout() {
  return (
    <div className="min-h-screen">
      <Navigation />
      <main>
        <Outlet /> {/* Child routes render here */}
      </main>
      <Footer />
    </div>
  )
}
```

## Routing Patterns

### Basic Routing

```tsx
// src/App.tsx
<Routes>
  <Route path="/" element={<Layout />}>
    <Route index element={<Home />} />          {/* / */}
    <Route path="about" element={<About />} />  {/* /about */}
    <Route path="*" element={<NotFound />} />   {/* 404 */}
  </Route>
</Routes>
```

### Nested Routes

```tsx
<Route path="users" element={<UsersLayout />}>
  <Route index element={<UserList />} />           {/* /users */}
  <Route path=":id" element={<UserDetail />} />    {/* /users/123 */}
  <Route path=":id/edit" element={<UserEdit />} /> {/* /users/123/edit */}
</Route>
```

### Programmatic Navigation

```tsx
import { useNavigate } from 'react-router-dom'

function MyComponent() {
  const navigate = useNavigate()

  const handleSubmit = () => {
    // Do something
    navigate('/success')
  }
}
```

### URL Parameters

```tsx
import { useParams } from 'react-router-dom'

function UserDetail() {
  const { id } = useParams() // Get :id from URL
  const { data } = useApi(() => fetchUser(id!))
  // ...
}
```

### Query Parameters

```tsx
import { useSearchParams } from 'react-router-dom'

function SearchPage() {
  const [searchParams, setSearchParams] = useSearchParams()
  const query = searchParams.get('q')

  // Update query: setSearchParams({ q: 'new-query' })
}
```

## State Management Patterns

### 1. Component State (useState)

For local, UI-only state:

```tsx
function Counter() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(count + 1)}>{count}</button>
}
```

### 2. Shared State (Context)

For state shared across multiple components:

```tsx
// contexts/AuthContext.tsx
const AuthContext = createContext<AuthContextType | null>(null)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)

  return (
    <AuthContext.Provider value={{ user, setUser }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) throw new Error('useAuth must be used within AuthProvider')
  return context
}

// Usage in component
const { user } = useAuth()
```

### 3. Server State (Custom Hooks)

For data from API:

```tsx
const { data, loading, error } = useApi(fetchUsers)
```

## Custom Hooks Pattern

### When to Create a Custom Hook

- Reusable stateful logic
- Abstracting complex state management
- Sharing logic across components

### Example: useApi Hook

```tsx
export function useApi<T>(apiFunction: () => Promise<T>) {
  const [data, setData] = useState<T | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  const execute = async () => {
    try {
      setLoading(true)
      const result = await apiFunction()
      setData(result)
    } catch (err) {
      setError(err as Error)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => { execute() }, [])

  return { data, loading, error, refetch: execute }
}
```

### Example: useLocalStorage Hook

```tsx
export function useLocalStorage<T>(key: string, initialValue: T) {
  const [value, setValue] = useState<T>(() => {
    const stored = localStorage.getItem(key)
    return stored ? JSON.parse(stored) : initialValue
  })

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(value))
  }, [key, value])

  return [value, setValue] as const
}
```

## API Service Pattern

### Service Structure

```tsx
// services/api.ts

// 1. Create axios instance
const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 30000,
})

// 2. Add interceptors
api.interceptors.request.use((config) => {
  // Add auth token
  const token = localStorage.getItem('auth_token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

// 3. Define API functions
export const fetchUsers = async (): Promise<User[]> => {
  const response = await api.get<ApiResponse<User[]>>('/users')
  return response.data.data
}
```

### API Function Pattern

```tsx
// GET request
export const fetchUser = async (id: string): Promise<User> => {
  const response = await api.get<ApiResponse<User>>(`/users/${id}`)
  return response.data.data
}

// POST request
export const createUser = async (input: CreateUserInput): Promise<User> => {
  const response = await api.post<ApiResponse<User>>('/users', input)
  return response.data.data
}

// PUT request
export const updateUser = async (id: string, input: UpdateUserInput): Promise<User> => {
  const response = await api.put<ApiResponse<User>>(`/users/${id}`, input)
  return response.data.data
}

// DELETE request
export const deleteUser = async (id: string): Promise<void> => {
  await api.delete(`/users/${id}`)
}
```

### Error Handling in API Service

```tsx
api.interceptors.response.use(
  (response) => response,
  (error: AxiosError<ApiError>) => {
    // Handle 401 - redirect to login
    if (error.response?.status === 401) {
      localStorage.removeItem('auth_token')
      window.location.href = '/login'
    }

    // Extract error message
    const message = error.response?.data?.error || 'An error occurred'
    return Promise.reject(new Error(message))
  }
)
```

## TypeScript Patterns

### Type Definitions

```tsx
// types/index.ts

// Data models
export interface User {
  id: string
  email: string
  name: string
  created_at: string
}

// Input types (for forms)
export interface CreateUserInput {
  email: string
  name: string
}

// API response wrappers
export interface ApiResponse<T> {
  data: T
  meta?: {
    total?: number
    page?: number
  }
}

// Component props
export interface ButtonProps {
  variant?: 'primary' | 'secondary'
  onClick?: () => void
  children: React.ReactNode
}
```

### Generic Components

```tsx
interface ListProps<T> {
  items: T[]
  renderItem: (item: T) => React.ReactNode
}

function List<T>({ items, renderItem }: ListProps<T>) {
  return <div>{items.map(renderItem)}</div>
}

// Usage
<List items={users} renderItem={(user) => <UserCard user={user} />} />
```

## Styling Patterns with Tailwind

### Inline Classes

```tsx
<div className="bg-white shadow-sm rounded-lg p-6">
  <h1 className="text-2xl font-bold text-gray-900">Title</h1>
</div>
```

### Component Classes (in index.css)

```css
@layer components {
  .btn-primary {
    @apply bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600;
  }
}
```

### Conditional Classes

```tsx
// Using template literals
<div className={`btn ${isPrimary ? 'btn-primary' : 'btn-secondary'}`}>

// Using clsx or classnames library
<div className={clsx('btn', {
  'btn-primary': isPrimary,
  'btn-secondary': !isPrimary
})}>
```

### Responsive Design

```tsx
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
  {/* 1 column on mobile, 2 on tablet, 3 on desktop */}
</div>
```

## Form Handling Patterns

### Basic Form

```tsx
function LoginForm() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    await login({ email, password })
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        className="input"
      />
      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        className="input"
      />
      <button type="submit" className="btn-primary">Login</button>
    </form>
  )
}
```

### Form with Validation

```tsx
const [errors, setErrors] = useState<Record<string, string>>({})

const validate = (): boolean => {
  const newErrors: Record<string, string> = {}

  if (!email) newErrors.email = 'Email is required'
  if (!password) newErrors.password = 'Password is required'

  setErrors(newErrors)
  return Object.keys(newErrors).length === 0
}

const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault()
  if (validate()) {
    await login({ email, password })
  }
}
```

## Performance Optimization

### Code Splitting

```tsx
import { lazy, Suspense } from 'react'

const Dashboard = lazy(() => import('./pages/Dashboard'))

<Suspense fallback={<Loading />}>
  <Dashboard />
</Suspense>
```

### Memoization

```tsx
// Memoize expensive computations
const sortedUsers = useMemo(() => {
  return users.sort((a, b) => a.name.localeCompare(b.name))
}, [users])

// Memoize callbacks
const handleClick = useCallback(() => {
  doSomething(id)
}, [id])

// Memoize components
const MemoizedComponent = memo(MyComponent)
```

### Virtual Scrolling

For long lists, use libraries like `react-window` or `react-virtual`.

## Testing Patterns

### Component Tests

```tsx
import { render, screen } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import Home from './pages/Home'

test('renders home page', () => {
  render(
    <BrowserRouter>
      <Home />
    </BrowserRouter>
  )
  expect(screen.getByText(/Welcome/i)).toBeInTheDocument()
})
```

### Testing with User Interactions

```tsx
import { render, screen, fireEvent } from '@testing-library/react'

test('button click increments counter', () => {
  render(<Counter />)
  const button = screen.getByText(/increment/i)
  fireEvent.click(button)
  expect(screen.getByText(/count: 1/i)).toBeInTheDocument()
})
```

## Common Patterns

### Loading States

```tsx
if (loading) return <div className="animate-spin">Loading...</div>
if (error) return <div className="text-red-500">Error: {error.message}</div>
if (!data) return <div>No data</div>

return <div>{/* Render data */}</div>
```

### Error Boundaries

```tsx
class ErrorBoundary extends React.Component<Props, State> {
  state = { hasError: false }

  static getDerivedStateFromError() {
    return { hasError: true }
  }

  componentDidCatch(error: Error, info: React.ErrorInfo) {
    console.error('Error:', error, info)
  }

  render() {
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>
    }
    return this.props.children
  }
}
```

### Modal Pattern

```tsx
function Modal({ isOpen, onClose, children }: ModalProps) {
  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
      <div className="bg-white rounded-lg p-6 max-w-md w-full">
        {children}
        <button onClick={onClose}>Close</button>
      </div>
    </div>
  )
}
```

## Adding New Features

### Adding a New Page

1. **Create page component** (`src/pages/NewPage.tsx`):
```tsx
export default function NewPage() {
  return <div>New Page</div>
}
```

2. **Add route** (`src/App.tsx`):
```tsx
<Route path="new" element={<NewPage />} />
```

3. **Add navigation** (`src/components/Layout.tsx`):
```tsx
<Link to="/new">New Page</Link>
```

### Adding State Management (Context)

1. **Create context** (`src/contexts/ThemeContext.tsx`)
2. **Wrap app** (`src/main.tsx`):
```tsx
<ThemeProvider>
  <App />
</ThemeProvider>
```
3. **Use in components**:
```tsx
const { theme, setTheme } = useTheme()
```

## Best Practices Summary

1. **Components** - Small, single responsibility, reusable
2. **Props** - Always type props with interfaces
3. **State** - Keep state as local as possible
4. **Effects** - Always specify dependencies
5. **Keys** - Use stable, unique keys for lists
6. **API** - Keep API logic in services, not components
7. **Types** - Define types in `types/`, import with `@/types`
8. **Styling** - Use Tailwind utilities, extract to components for reuse
9. **Hooks** - Extract reusable logic into custom hooks
10. **Testing** - Write tests for critical paths

## Conventions

- **File names** - PascalCase for components, camelCase for utilities
- **Component exports** - Default export for components
- **Props** - Named with descriptive interfaces
- **Handlers** - Prefix with `handle` (handleClick, handleSubmit)
- **Boolean props** - Prefix with `is`, `has`, `should` (isOpen, hasError)
- **Event handlers** - Use `on` prefix in prop names (onClick, onChange)

---

**When in doubt:** Look at existing components (`Layout.tsx`, `Home.tsx`) as reference implementations.
