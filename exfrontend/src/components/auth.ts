// src/auth.js
import { account, databases} from './appwrite'
import { OAuthProvider } from "appwrite"

const did = process.env.DATABASE_ID || ''
const cid = process.env.COLLECTION_ID || ''

export const loginWithGoogle = async () => {
    await account.createOAuth2Session(
        OAuthProvider.Google,
        'http://localhost:5173/gsign',
        'http://localhost:5173/'
    )
}
export const addUser = async () => {
  try {
    const user = await account.get();
    const id = user.$id;

    // Attempt to fetch the document
    const result = await databases.getDocument(
      did,
      cid,
      id
    );
    if(result){
      return result
    }
  } catch (error: any) {

    // Create the document if it doesn't exist
    if (error.code === 404) { // Assuming 404 is the "not found" error
      const user = await account.get(); // Re-fetch user for robustness
      const result = await databases.createDocument(
        did,
        cid,
        user.$id,
        { name: user.name || 'Unknown User' }
      );

      if(result){
        return result
      }
    } else {
    }
  }
};

export const newcourse = async () => {
  try {
    const user = await account.get();
    const id = user.$id;

    // Attempt to fetch the document
    const result = await databases.getDocument(
      did,
      cid,
      id
    );

    const enrolled = result.enrolled + 1;
  const uresult = await databases.updateDocument(
      did,
      cid, // collectionId
    id, // documentId
    {'enrolled': enrolled}, // data (optional)
);

if(uresult){
  return uresult
}}
catch(error){
}
}


export const updateProgress = async (courseId: any, progress: any) => {
  try {
    const user = await account.get();
    const id = user.$id;

    // Fetch the existing document
    const result = await databases.getDocument(
      did,
      cid,
      id // Document ID
    );

    // Ensure courses and progress arrays are initialized
    const courses = Array.isArray(result.courses) ? [...result.courses] : [];
    const progresses = Array.isArray(result.progress) ? [...result.progress] : [];

    if (courses.indexOf(courseId) !== -1) { 
      const index = courses.indexOf(courseId);
      progresses[index] = progress; // Update existing progress
  } else {
      courses.push(courseId);
      progresses.push(progress);
  }
  
    // Update the document
    const updatedResult = await databases.updateDocument(
      did,
      cid,
      id, // Document ID
      { courses, progress: progresses } // Data to update
    );

    if(updatedResult){
      return updatedResult
    }
  } catch (error) {

  }
};

export async function getProgress(courseId: any) {
  try {
    const user = await account.get();
    const id = user.$id;

    // Attempt to fetch the document
    const result = await databases.getDocument(
      did,
      cid,
      id
    );

    const progresses = Array.isArray(result.progress) ? [...result.progress] : [];
    const progress = progresses[courseId]
    return progress;
  }
    catch(error){
    }
}


export const logoutUser = async () => {
    try {
      await account.get();
      await account.deleteSession('current');
    } catch (error) {
    }
  };
export const getUser = async () => {
    return await account.get();
}

