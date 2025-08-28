#!/bin/bash

# Script to generate TypeScript client from OpenAPI specification
# Usage: ./generate-client.sh [api-name]
# If no api-name is provided, it will generate from the main openapi.yml

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PLATFORM_DIR="../yabadu-platform"
OUTPUT_DIR="./generated"
DOCKER_IMAGE="openapitools/openapi-generator-cli:latest"

# Determine which OpenAPI spec to use
API_NAME=${1:-"main"}

case "$API_NAME" in
  "main")
    OPENAPI_FILE="$PLATFORM_DIR/openapi.yml"
    PACKAGE_NAME="yabadu-platform-client"
    ;;
  "onboarding")
    OPENAPI_FILE="$PLATFORM_DIR/onboarding.openapi.yml"
    PACKAGE_NAME="yabadu-platform-client-onboarding"
    OUTPUT_DIR="$OUTPUT_DIR/onboarding"
    ;;
  "registration")
    OPENAPI_FILE="$PLATFORM_DIR/registration.openapi.yml"
    PACKAGE_NAME="yabadu-platform-client-registration"
    OUTPUT_DIR="$OUTPUT_DIR/registration"
    ;;
  *)
    echo -e "${RED}Unknown API name: $API_NAME${NC}"
    echo "Usage: $0 [main|onboarding|registration]"
    exit 1
    ;;
esac

# Check if OpenAPI file exists
if [ ! -f "$OPENAPI_FILE" ]; then
    echo -e "${RED}Error: OpenAPI file not found: $OPENAPI_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}Generating TypeScript client for: $API_NAME${NC}"
echo -e "${YELLOW}OpenAPI file: $OPENAPI_FILE${NC}"
echo -e "${YELLOW}Output directory: $OUTPUT_DIR${NC}"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Copy OpenAPI file to current directory for Docker volume mounting
cp "$OPENAPI_FILE" "./temp-openapi.yml"

# Generate TypeScript client using Docker
echo -e "${GREEN}Running OpenAPI Generator...${NC}"

docker run --rm \
  -v "${PWD}:/local" \
  "$DOCKER_IMAGE" generate \
  -i /local/temp-openapi.yml \
  -g typescript-fetch \
  -o /local/$OUTPUT_DIR \
  --additional-properties=npmName=$PACKAGE_NAME,supportsES6=true,npmVersion=1.0.0,typescriptThreePlus=true \
  --skip-validate-spec

# Check if generation was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Client generated successfully!${NC}"
    
    # Clean up temporary file
    rm -f ./temp-openapi.yml
    
    # Already using typescript-fetch as primary generator
    
    echo -e "${GREEN}Output location: $OUTPUT_DIR${NC}"
else
    echo -e "${RED}✗ Failed to generate client${NC}"
    rm -f ./temp-openapi.yml
    exit 1
fi