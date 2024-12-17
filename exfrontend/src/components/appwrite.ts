import { Client, Account, Databases } from 'appwrite'
const project = process.env.APROJECT_ID || ''

const client = new Client()
  .setEndpoint('https://cloud.appwrite.io/v1')
  .setProject(project)

  const account = new Account(client);

  const databases = new Databases(client);
export { account, databases }

