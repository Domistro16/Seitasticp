import { Client, Account, Databases, OAuthProvider } from 'appwrite'

const project = import.meta.env.VITE_APROJECT_ID || ''

const client = new Client()
  .setEndpoint('https://cloud.appwrite.io/v1')
  .setProject(project)

  const account = new Account(client);

  const databases = new Databases(client);
export { account, databases, OAuthProvider }

