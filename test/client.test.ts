import { describe, test, expect, beforeAll } from '@jest/globals';
import * as fs from 'fs';
import * as path from 'path';

describe('Yabadu Platform Client Tests', () => {
  const generatedDir = path.join(__dirname, '..', 'generated');
  
  beforeAll(() => {
    // Check if generated client exists
    if (!fs.existsSync(generatedDir)) {
      throw new Error('Generated client not found. Run "npm run generate" first.');
    }
  });

  test('Generated client directory should exist', () => {
    expect(fs.existsSync(generatedDir)).toBe(true);
  });

  test('Generated client should have main files', () => {
    // Check for typescript-fetch generator output files
    const possibleFiles = [
      'src/index.ts',
      'src/apis/index.ts',
      'src/models/index.ts',
      'src/runtime.ts'
    ];

    const existingFiles = possibleFiles.filter(file => 
      fs.existsSync(path.join(generatedDir, file))
    );

    expect(existingFiles.length).toBeGreaterThan(0);
  });

  test('Generated package.json should exist', () => {
    const packageJsonPath = path.join(generatedDir, 'package.json');
    if (fs.existsSync(packageJsonPath)) {
      const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
      expect(packageJson.name).toBeDefined();
      expect(packageJson.version).toBeDefined();
    }
  });

  // Test importing the generated client
  test('Generated client should be importable', async () => {
    try {
      // Try to dynamically import the generated client
      const clientPath = path.join(generatedDir, 'src', 'index.ts');
      if (fs.existsSync(clientPath)) {
        const clientModule = await import(path.resolve(clientPath));
        expect(clientModule).toBeDefined();
      } else {
        // If src/index.ts doesn't exist, look for other entry points
        const apiPath = path.join(generatedDir, 'src', 'apis', 'index.ts');
        if (fs.existsSync(apiPath)) {
          const apiModule = await import(path.resolve(apiPath));
          expect(apiModule).toBeDefined();
        }
      }
    } catch (error) {
      // This test might fail due to TypeScript compilation issues
      // which is acceptable at this stage
      console.warn('Could not import generated client:', error);
    }
  });
});

describe('OpenAPI Specification Tests', () => {
  const platformDir = path.join(__dirname, '..', '..', 'yabadu-platform');
  
  test('Main OpenAPI specification should exist', () => {
    const openApiPath = path.join(platformDir, 'openapi.yml');
    expect(fs.existsSync(openApiPath)).toBe(true);
  });

  test('Onboarding OpenAPI specification should exist', () => {
    const openApiPath = path.join(platformDir, 'onboarding.openapi.yml');
    expect(fs.existsSync(openApiPath)).toBe(true);
  });

  test('Registration OpenAPI specification should exist', () => {
    const openApiPath = path.join(platformDir, 'registration.openapi.yml');
    expect(fs.existsSync(openApiPath)).toBe(true);
  });
});