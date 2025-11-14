export default function About() {
  return (
    <div className="max-w-3xl mx-auto">
      <div className="bg-white shadow-sm rounded-lg p-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">About ProjectName</h1>

        <div className="prose prose-lg">
          <p className="text-gray-600 mb-4">
            This is a production-ready React application template built with modern
            technologies and best practices.
          </p>

          <h2 className="text-2xl font-semibold text-gray-900 mt-8 mb-4">
            Tech Stack
          </h2>

          <ul className="space-y-2 text-gray-600">
            <li className="flex items-start">
              <span className="text-blue-500 mr-2">•</span>
              <span><strong>React 18</strong> - Latest version with concurrent features</span>
            </li>
            <li className="flex items-start">
              <span className="text-blue-500 mr-2">•</span>
              <span><strong>TypeScript</strong> - Type safety and better DX</span>
            </li>
            <li className="flex items-start">
              <span className="text-blue-500 mr-2">•</span>
              <span><strong>Vite</strong> - Fast build tool and dev server</span>
            </li>
            <li className="flex items-start">
              <span className="text-blue-500 mr-2">•</span>
              <span><strong>React Router</strong> - Client-side routing</span>
            </li>
            <li className="flex items-start">
              <span className="text-blue-500 mr-2">•</span>
              <span><strong>Tailwind CSS</strong> - Utility-first CSS framework</span>
            </li>
            <li className="flex items-start">
              <span className="text-blue-500 mr-2">•</span>
              <span><strong>Axios</strong> - HTTP client for API requests</span>
            </li>
          </ul>

          <h2 className="text-2xl font-semibold text-gray-900 mt-8 mb-4">
            Features
          </h2>

          <ul className="space-y-2 text-gray-600">
            <li className="flex items-start">
              <span className="text-green-500 mr-2">✓</span>
              <span>Component-based architecture</span>
            </li>
            <li className="flex items-start">
              <span className="text-green-500 mr-2">✓</span>
              <span>Type-safe development with TypeScript</span>
            </li>
            <li className="flex items-start">
              <span className="text-green-500 mr-2">✓</span>
              <span>Fast hot module replacement</span>
            </li>
            <li className="flex items-start">
              <span className="text-green-500 mr-2">✓</span>
              <span>Responsive design with Tailwind</span>
            </li>
            <li className="flex items-start">
              <span className="text-green-500 mr-2">✓</span>
              <span>API service layer for backend integration</span>
            </li>
            <li className="flex items-start">
              <span className="text-green-500 mr-2">✓</span>
              <span>Custom hooks for reusable logic</span>
            </li>
            <li className="flex items-start">
              <span className="text-green-500 mr-2">✓</span>
              <span>Environment-based configuration</span>
            </li>
          </ul>
        </div>
      </div>
    </div>
  )
}
