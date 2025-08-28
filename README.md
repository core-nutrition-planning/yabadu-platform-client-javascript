# Yabadu Platform JavaScript/TypeScript Client

This project generates a JavaScript/TypeScript client for the Yabadu Platform API using OpenAPI Generator.

## Prerequisites

- Docker (for running OpenAPI Generator)
- Node.js (v16 or higher)
- npm

## Quick Start

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Generate the client:**
   ```bash
   npm run generate
   ```

3. **Run tests:**
   ```bash
   npm test
   ```

4. **Build the project:**
   ```bash
   npm run build
   ```

## Available Scripts

### Generation Scripts

- `npm run generate` - Generate the main API client from `openapi.yml`
- `npm run generate:onboarding` - Generate client from `onboarding.openapi.yml`
- `npm run generate:registration` - Generate client from `registration.openapi.yml`
- `npm run generate:all` - Generate all API clients

### Development Scripts

- `npm run build` - Compile TypeScript to JavaScript
- `npm test` - Run the test suite
- `npm run test:watch` - Run tests in watch mode
- `npm run clean` - Clean generated files and build output
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier

### Testing Script

- `./scripts/test-client.sh` - Complete test suite that generates clients and runs all tests

## Generated Client Structure

The generated clients will be placed in the `generated/` directory:

- `generated/` - Main API client
- `generated/onboarding/` - Onboarding API client
- `generated/registration/` - Registration API client

## OpenAPI Generator Configuration

This project uses the `openapitools/openapi-generator-cli` Docker image with the following generators:

1. **Primary**: `typescript` - Standard TypeScript generator
2. **Fallback**: `typescript-fetch` - Used if the standard TypeScript generator fails

### Generator Options

- `npmName`: Package name for the generated client
- `supportsES6`: Enable ES6+ features
- `npmVersion`: Version for the generated package
- `withInterfaces`: Generate TypeScript interfaces
- `typescriptThreePlus`: Use TypeScript 3+ features (for typescript-fetch)

## Usage Example

```typescript
// Import the generated client
import { Configuration, DefaultApi } from './generated';

// Configure the client
const config = new Configuration({
  basePath: 'https://api.yabadu.com',
  // Add authentication if needed
});

// Create API instance
const api = new DefaultApi(config);

// Use the API
async function example() {
  try {
    const response = await api.someEndpoint();
    console.log(response);
  } catch (error) {
    console.error('API call failed:', error);
  }
}
```

## Development

### Adding New OpenAPI Specifications

1. Place the OpenAPI YAML file in the parent `yabadu-platform` directory
2. Update the `generate-client.sh` script to include the new specification
3. Add a corresponding npm script in `package.json`

### Customizing Generation

Edit the `scripts/generate-client.sh` file to:
- Change generator options
- Add post-generation processing
- Customize output directories

## Testing

The test suite includes:

- Verification that OpenAPI specifications exist
- Validation of generated client structure
- Import tests for generated code
- Basic functionality tests

Run the complete test suite with:
```bash
./scripts/test-client.sh
```

## Troubleshooting

### Docker Issues

Ensure Docker is running and you have permission to pull images:
```bash
docker pull openapitools/openapi-generator-cli:latest
```

### Generation Failures

If the `typescript` generator fails, the script will automatically fallback to `typescript-fetch`. Check the console output for specific error messages.

### Missing OpenAPI Files

Ensure the Yabadu Platform repository is in the correct relative location:
```
project-root/
├── yabadu-platform/          # Main platform repo
│   ├── openapi.yml
│   ├── onboarding.openapi.yml
│   └── registration.openapi.yml
└── yabadu-platform-client-javascript/  # This project
    ├── scripts/
    └── package.json
```

## License

MIT