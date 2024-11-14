import axios from 'axios';

const getApiUrl = () => {
  // First try runtime config
  const runtimeUrl = window.ENV_CONFIG?.REACT_APP_API_URL;
  if (runtimeUrl) {
    console.log('Using runtime API URL:', runtimeUrl);
    return runtimeUrl;
  }

  // Then try build-time env
  const buildTimeUrl = process.env.REACT_APP_API_URL;
  if (buildTimeUrl) {
    console.log('Using build-time API URL:', buildTimeUrl);
    return buildTimeUrl;
  }

  // Finally, fallback to default
  const defaultUrl = 'http://localhost:3005';
  console.log('Using default API URL:', defaultUrl);
  return defaultUrl;
};

const API_URL = getApiUrl();

console.log('Using API URL:', API_URL); // Helpful for debugging

export const todoService = {
  getAllTodos: async () => {
    try {
      const response = await axios.get(`${API_URL}/api/todos`);
      return response.data;
    } catch (error) {
      console.error('Error fetching todos:', error);
      throw new Error(
        error.response?.data?.message || 
        'Failed to fetch todos. Please check API configuration.'
      );
    }
  },

  updateTodoState: async (id, state) => {
    const response = await axios.patch(`${API_URL}/api/todos/${id}`, { state });
    return response.data;
  },

  createTodo: async (title, description) => {
    const response = await axios.post(`${API_URL}/api/todos`, {
      title,
      description
    });
    return response.data;
  },

  deleteTodo: async (id) => {
    await axios.delete(`${API_URL}/api/todos/${id}`);
  },

  updateTodo: async (id, { title, description }) => {
    const response = await axios.put(`${API_URL}/api/todos/${id}`, {
      title,
      description
    });
    return response.data;
  }
}; 