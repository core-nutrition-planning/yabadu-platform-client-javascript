# GitHub Actions Workflows

This repository uses GitHub Actions to automate client generation and publishing.

## Workflows

### 1. Generate and Publish Client (`generate-and-publish.yml`)

**Triggers:**
- Push to `main` or `master` branches
- Pull requests to `main` or `master` branches
- Manual workflow dispatch with option to publish

**What it does:**
1. Generates TypeScript client from `openapi.yml` using OpenAPI Generator
2. Builds and tests the generated client
3. Publishes to GitHub Packages (on main/master branch or manual trigger)
4. Generates TypeDoc documentation

**Required Secrets:**
- `GITHUB_TOKEN` (automatically provided by GitHub Actions)

### 2. Sync OpenAPI Specification (`sync-openapi.yml`)

**Triggers:**
- Daily at 2 AM UTC
- Manual workflow dispatch with optional source URL

**What it does:**
1. Downloads the latest OpenAPI specification from the API
2. Checks for changes compared to the committed version
3. Creates a pull request if changes are detected

**Configuration:**
- Update the default API URL in the workflow file
- The workflow will create PRs automatically when the API spec changes

## Setup Instructions

### 1. Repository Settings

Enable GitHub Packages:
1. Go to Settings → Actions → General
2. Under "Workflow permissions", select "Read and write permissions"
3. Check "Allow GitHub Actions to create and approve pull requests"

### 2. Package Configuration

The package is configured to publish to GitHub Packages with the scope `@<org>/<repo>`.

To install the published package in another project:

```bash
# Create .npmrc file in your project
echo "@YOUR_ORG:registry=https://npm.pkg.github.com" > .npmrc

# Install the package
npm install @YOUR_ORG/yabadu-platform-client-javascript
```

### 3. Authentication for Private Packages

If the package is private, you'll need to authenticate:

```bash
# Login to GitHub Package Registry
npm login --scope=@YOUR_ORG --registry=https://npm.pkg.github.com
# Username: YOUR_GITHUB_USERNAME
# Password: YOUR_GITHUB_PERSONAL_ACCESS_TOKEN
# Email: YOUR_EMAIL
```

## Manual Workflow Triggers

### Generate and Publish

```bash
# Using GitHub CLI
gh workflow run generate-and-publish.yml --field publish=true
```

### Sync OpenAPI Spec

```bash
# Using GitHub CLI with custom URL
gh workflow run sync-openapi.yml --field source_url=https://api.example.com/openapi
```

## Version Management

- Version numbers are automatically generated using the GitHub run number
- Format: `1.<run_number>.0`
- Each successful build on main/master creates a new version

## Artifacts

The workflows produce the following artifacts:
- `generated-client`: The generated TypeScript client code
- `api-docs`: TypeDoc documentation (30-day retention)

## Troubleshooting

### Client Generation Fails

1. Check that `openapi.yml` is valid
2. Verify Docker is available in the GitHub Actions runner
3. Check OpenAPI Generator compatibility with your spec

### Publishing Fails

1. Ensure repository has package write permissions
2. Verify package.json has correct scope and registry
3. Check that version number is not already published

### OpenAPI Sync Issues

1. Verify the API endpoint is accessible
2. Check that the downloaded spec is valid YAML/JSON
3. Ensure workflow has permission to create pull requests