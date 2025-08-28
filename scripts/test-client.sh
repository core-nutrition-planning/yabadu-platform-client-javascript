#!/bin/bash

# Script to test the generated TypeScript client
# This script will generate the client and run tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Yabadu Platform Client Test Suite ===${NC}"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is required but not installed.${NC}"
    exit 1
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo -e "${RED}Error: npm is required but not installed.${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: Installing dependencies...${NC}"
npm install

echo -e "${YELLOW}Step 2: Cleaning previous builds...${NC}"
npm run clean || true

echo -e "${YELLOW}Step 3: Generating main API client...${NC}"
npm run generate

echo -e "${YELLOW}Step 4: Generating onboarding API client...${NC}"
npm run generate:onboarding || echo -e "${YELLOW}Warning: Onboarding API generation failed or skipped${NC}"

echo -e "${YELLOW}Step 5: Generating registration API client...${NC}"
npm run generate:registration || echo -e "${YELLOW}Warning: Registration API generation failed or skipped${NC}"

echo -e "${YELLOW}Step 6: Running tests...${NC}"
npm test

echo -e "${YELLOW}Step 7: Checking generated files...${NC}"
if [ -d "./generated" ]; then
    echo -e "${GREEN}✓ Generated directory exists${NC}"
    echo -e "${BLUE}Generated files:${NC}"
    find ./generated -name "*.ts" -o -name "*.js" -o -name "package.json" | head -20
    
    if [ "$(find ./generated -name "*.ts" | wc -l)" -gt 0 ]; then
        echo -e "${GREEN}✓ TypeScript files generated successfully${NC}"
    else
        echo -e "${YELLOW}Warning: No TypeScript files found in generated directory${NC}"
    fi
else
    echo -e "${RED}✗ Generated directory not found${NC}"
    exit 1
fi

echo -e "${GREEN}=== Test completed successfully! ===${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Review generated client code in ./generated/"
echo -e "  2. Import and use the client in your application"
echo -e "  3. Run 'npm run build' to compile TypeScript"