// Example usage of the Yabadu Platform TypeScript client

import {
  Configuration,
  SystemApi,
  ApplicationsApi,
  AuthenticationApi,
  TargetGenerationApi,
  DefaultApi
} from '../generated/src';

// Configuration with base URL and authentication
const configuration = new Configuration({
  basePath: 'https://api.yabadu.com', // Replace with actual API base URL
  // Add authentication configuration here
  // accessToken: 'your-access-token',
  // apiKey: 'your-api-key',
  // username: 'your-username',
  // password: 'your-password',
});

// Example 1: Using System API to get available units
async function getSystemUnits() {
  const systemApi = new SystemApi(configuration);

  try {
    const response = await systemApi.systemUnitsGet();
    console.log('Available units:', response);
    return response;
  } catch (error) {
    console.error('Error fetching units:', error);
    throw error;
  }
}

// Example 2: Using System API to get genders
async function getSystemGenders() {
  const systemApi = new SystemApi(configuration);

  try {
    const response = await systemApi.systemGendersGet();
    console.log('Available genders:', response);
    return response;
  } catch (error) {
    console.error('Error fetching genders:', error);
    throw error;
  }
}

// Example 3: Using Applications API
async function getApplications() {
  const applicationsApi = new ApplicationsApi(configuration);

  try {
    // Get private label applications
    const privateLabelApps = await applicationsApi.privateLabelApplicationsGet();
    console.log('Private Label Applications:', privateLabelApps);

    return { privateLabelApps };
  } catch (error) {
    console.error('Error fetching applications:', error);
    throw error;
  }
}

// Example 4: Error handling with typed responses
async function handleApiErrors() {
  const systemApi = new SystemApi(configuration);

  try {
    const response = await systemApi.systemGendersGet();
    return response;
  } catch (error: any) {
    if (error.response) {
      // Server responded with error status
      console.error('API Error Status:', error.response.status);
      console.error('API Error Data:', error.response.data);
    } else if (error.request) {
      // Network error
      console.error('Network Error:', error.message);
    } else {
      // Other error
      console.error('Error:', error.message);
    }
    throw error;
  }
}

// Example usage in an async function
async function main() {
  try {
    // Fetch system data
    const units = await getSystemUnits();
    const genders = await getSystemGenders();

    // Fetch applications
    const applications = await getApplications();

    console.log('API calls completed successfully');
  } catch (error) {
    console.error('Main execution failed:', error);
  }
}

// Export for use in other files
export {
  getSystemUnits,
  getSystemGenders,
  getApplications,
  handleApiErrors,
  configuration
};

// Run example if this file is executed directly
if (require.main === module) {
  main();
}