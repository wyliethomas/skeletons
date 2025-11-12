# project-name

A modern React application built with Vite, TypeScript, and Tailwind CSS.

## Features

- **React 18** - Latest version with concurrent features
- **TypeScript** - Type-safe development
- **Vite** - Lightning-fast build tool and dev server
- **React Router** - Client-side routing
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client for API requests
- **ESLint & Prettier** - Code quality and formatting
- **Vitest** - Fast unit testing
- **Docker Ready** - Production-ready Docker setup with Nginx

## Quick Start (Docker) - Recommended

Docker setup includes optimized production build served by Nginx.

```bash
# 1. Copy environment files
cp .env.example .env

# 2. Update .env with your project name
# Edit COMPOSE_NAME in .env

# 3. Run setup script (builds Docker image)
./setup.sh

# 4. Start the application
docker compose up

# Or run in the background
docker compose up -d

# View logs
docker compose logs -f web
```

Visit `http://localhost:5173` to see your app.

### Docker Commands

```bash
# Stop the application
docker compose down

# Rebuild after code changes
docker compose build

# View logs
docker compose logs -f web

# Rebuild and restart
./setup.sh && docker compose up
```

## Quick Start (Local)

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Open http://localhost:5173 in your browser
```

## Development

### Prerequisites

- Node.js 18+ or higher
- npm or yarn

### Available Scripts

```bash
# Development
npm run dev          # Start dev server with hot reload

# Building
npm run build        # Build for production
npm run preview      # Preview production build locally

# Code Quality
npm run lint         # Run ESLint
npm run format       # Format code with Prettier

# Testing
npm test             # Run tests
npm run test:ui      # Run tests with UI
```

## Project Structure

```
src/
├── components/        # Reusable UI components
│   └── Layout.tsx    # Main layout with navigation
├── pages/            # Page components (route destinations)
│   ├── Home.tsx
│   ├── About.tsx
│   └── NotFound.tsx
├── hooks/            # Custom React hooks
│   └── useApi.ts     # API call hook
├── services/         # External services and API
│   └── api.ts        # Axios instance and API methods
├── types/            # TypeScript type definitions
│   └── index.ts
├── utils/            # Utility functions
├── App.tsx           # Main app component with routing
├── main.tsx          # Application entry point
└── index.css         # Global styles with Tailwind
```

## Routing

Routes are defined in `src/App.tsx` using React Router:

```tsx
<Route path="/" element={<Layout />}>
  <Route index element={<Home />} />
  <Route path="about" element={<About />} />
  <Route path="*" element={<NotFound />} />
</Route>
```

## API Integration

API calls are centralized in `src/services/api.ts`:

```typescript
import { fetchUsers, createUser } from '@/services/api'

// In your component
const users = await fetchUsers()
const newUser = await createUser({ name: 'John', email: 'john@example.com' })
```

### API Configuration

Configure the API base URL in `.env`:

```bash
VITE_API_URL=http://localhost:8080/api/v1
VITE_API_TIMEOUT=30000
```

### Authentication

The API service includes automatic token handling:

```typescript
// Token is automatically added to requests
localStorage.setItem('auth_token', 'your-token')

// Token is automatically removed on 401 responses
```

## Custom Hooks

### useApi Hook

A custom hook for API calls with loading states:

```typescript
import { useApi } from '@/hooks/useApi'
import { fetchUsers } from '@/services/api'

function MyComponent() {
  const { data, loading, error, execute } = useApi(fetchUsers, {
    immediate: true,
    onSuccess: (data) => console.log('Success!', data),
    onError: (error) => console.error('Error!', error),
  })

  if (loading) return <div>Loading...</div>
  if (error) return <div>Error: {error.message}</div>

  return <div>{/* Render data */}</div>
}
```

## Styling with Tailwind

Tailwind utility classes are available throughout the app:

```tsx
<div className="bg-white shadow-sm rounded-lg p-6">
  <h1 className="text-2xl font-bold text-gray-900">Hello World</h1>
  <button className="btn-primary">Click me</button>
</div>
```

### Custom Components

Pre-defined component classes in `src/index.css`:

- `.btn-primary` - Primary button styling
- `.btn-secondary` - Secondary button styling
- `.card` - Card container
- `.input` - Form input styling
- `.label` - Form label styling

### Theme Customization

Edit `tailwind.config.js` to customize colors, fonts, etc.:

```javascript
theme: {
  extend: {
    colors: {
      primary: { /* custom colors */ },
    },
  },
}
```

## TypeScript

### Type Definitions

Types are defined in `src/types/index.ts`:

```typescript
export interface User {
  id: string
  email: string
  name: string
}
```

### Path Aliases

Import using `@/` alias for cleaner imports:

```typescript
import { User } from '@/types'
import { fetchUsers } from '@/services/api'
import Button from '@/components/Button'
```

## Environment Variables

Create `.env` file from `.env.example`:

```bash
cp .env.example .env
```

All environment variables must be prefixed with `VITE_`:

```bash
VITE_API_URL=http://localhost:8080/api/v1
VITE_APP_NAME=project-name
```

Access in code:

```typescript
const apiUrl = import.meta.env.VITE_API_URL
```

## Building for Production

```bash
# Build the application
npm run build

# Preview the production build
npm run preview
```

The build output will be in the `dist/` directory.

### Deployment

#### Static Hosting (Netlify, Vercel, etc.)

1. Build command: `npm run build`
2. Publish directory: `dist`
3. Add environment variables in hosting dashboard

#### Docker

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## Testing

Tests use Vitest (compatible with Jest):

```bash
npm test
```

Example test:

```typescript
import { render, screen } from '@testing-library/react'
import Home from './pages/Home'

test('renders home page', () => {
  render(<Home />)
  expect(screen.getByText(/Welcome/i)).toBeInTheDocument()
})
```

## Code Quality

### ESLint

Lint your code:

```bash
npm run lint
```

### Prettier

Format your code:

```bash
npm run format
```

### VSCode Integration

Install recommended extensions:
- ESLint
- Prettier
- Tailwind CSS IntelliSense

## Best Practices

1. **Components** - Keep components small and focused
2. **Types** - Always use TypeScript types
3. **Hooks** - Extract reusable logic into custom hooks
4. **API** - Keep API logic in services layer
5. **Styling** - Use Tailwind utilities, create custom classes for reusable patterns
6. **Testing** - Write tests for critical functionality
7. **Environment** - Never commit `.env` files

## Common Tasks

### Adding a New Page

1. Create component in `src/pages/NewPage.tsx`
2. Add route in `src/App.tsx`:
   ```tsx
   <Route path="new" element={<NewPage />} />
   ```
3. Add navigation link in `src/components/Layout.tsx`

### Adding a New API Endpoint

1. Add types in `src/types/index.ts`
2. Add API function in `src/services/api.ts`:
   ```typescript
   export const fetchPosts = async (): Promise<Post[]> => {
     const response = await api.get<ApiResponse<Post[]>>('/posts')
     return response.data.data
   }
   ```
3. Use in component with `useApi` hook

### Adding a Custom Hook

1. Create file in `src/hooks/useMyHook.ts`
2. Export the hook function
3. Import and use in components

## Performance Tips

- Use `React.lazy()` for code splitting
- Implement virtual scrolling for long lists
- Memoize expensive computations with `useMemo`
- Prevent unnecessary re-renders with `memo` and `useCallback`
- Optimize images (use WebP, lazy loading)

## Troubleshooting

### Port already in use

Change port in `vite.config.ts`:

```typescript
server: {
  port: 3000,
}
```

### Module not found errors

Ensure TypeScript paths are configured correctly in `tsconfig.json` and `vite.config.ts`.

### Tailwind styles not working

1. Check `tailwind.config.js` content paths
2. Ensure `@tailwind` directives are in `src/index.css`
3. Restart dev server

## Next Steps

1. Add authentication (JWT, OAuth, etc.)
2. Implement state management (Context, Zustand, Redux)
3. Add form handling (React Hook Form)
4. Set up error boundary
5. Add analytics and monitoring
6. Implement PWA features
7. Set up CI/CD pipeline

See `CLAUDE_CONTEXT.md` for architecture details and patterns.
