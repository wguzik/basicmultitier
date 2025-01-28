import { useState, useEffect } from 'react';
import styled from 'styled-components';
import Column from './Column';
import { todoService, API_URL } from '../services/todoService';
import { TodoState } from '../types';

const BoardContainer = styled.div`
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  padding-bottom: 32px;

  @media (max-width: 768px) {
    grid-template-columns: 1fr;
    gap: 16px;
  }
`;

const EnvSection = styled.div`
  margin-top: 20px;
  padding: 16px;
  background: #f5f5f5;
  border-radius: 4px;
`;

const ErrorMessage = styled.div`
  margin: 20px 0;
  padding: 16px;
  background: #fee2e2;
  border: 1px solid #ef4444;
  border-radius: 4px;
  color: #dc2626;
  font-weight: 500;
`;

const StatusIndicator = styled.span.attrs(props => ({
  'data-connected': props.connected
}))`
  display: inline-block;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  margin-right: 8px;
  background-color: ${props => props['data-connected'] ? '#22c55e' : '#ef4444'};
`;

const StatusRow = styled.div`
  margin-top: 12px;
  display: flex;
  align-items: center;
`;

const Board = ({ refreshTrigger }) => {
  const [todos, setTodos] = useState([]);
  const [error, setError] = useState(null);
  const [apiStatus, setApiStatus] = useState(false);

  useEffect(() => {
    const fetchTodos = async () => {
      try {
        const data = await todoService.getAllTodos();
        setTodos(data);
        setError(null);
        setApiStatus(true);
      } catch (err) {
        console.error('Failed to fetch todos:', err);
        setError('Failed to connect to the API. Please check if the API URL is correctly configured.');
        setTodos([]);
        setApiStatus(false);
      }
    };
    fetchTodos();
  }, [refreshTrigger]);

  const moveCard = async (todo, newState) => {
    try {
      const updatedTodo = await todoService.updateTodoState(todo.id, newState);
      setTodos(todos.map(t => t.id === updatedTodo.id ? updatedTodo : t));
    } catch (error) {
      console.error('Failed to update todo:', error);
    }
  };

  const getColumnTodos = (state) => todos.filter(todo => todo.state === state);

  const handleDelete = async (id) => {
    try {
      await todoService.deleteTodo(id);
      setTodos(todos.filter(todo => todo.id !== id));
    } catch (error) {
      console.error('Failed to delete todo:', error);
      throw error;
    }
  };

  const handleEdit = async (id, updates) => {
    try {
      const updatedTodo = await todoService.updateTodo(id, updates);
      setTodos(todos.map(todo => 
        todo.id === id ? updatedTodo : todo
      ));
    } catch (error) {
      console.error('Failed to update todo:', error);
      throw error;
    }
  };

  return (
    <>
      <BoardContainer>
        <Column
          title="Todo"
          todos={getColumnTodos(TodoState.TODO)}
          onMoveRight={(todo) => moveCard(todo, TodoState.IN_PROGRESS)}
          onDelete={handleDelete}
          onEdit={handleEdit}
        />
        <Column
          title="In Progress"
          todos={getColumnTodos(TodoState.IN_PROGRESS)}
          onMoveLeft={(todo) => moveCard(todo, TodoState.TODO)}
          onMoveRight={(todo) => moveCard(todo, TodoState.DONE)}
          onDelete={handleDelete}
          onEdit={handleEdit}
        />
        <Column
          title="Done"
          todos={getColumnTodos(TodoState.DONE)}
          onMoveLeft={(todo) => moveCard(todo, TodoState.IN_PROGRESS)}
          onDelete={handleDelete}
          onEdit={handleEdit}
        />
      </BoardContainer>
      
      <EnvSection>
        <StatusRow>
          <strong>Api url: </strong>
          {`${API_URL}`}
        </StatusRow>
        <StatusRow>
          <strong>API Connection Status: </strong>
          <div style={{ display: 'flex', alignItems: 'center', marginLeft: '8px' }}>
            <StatusIndicator connected={apiStatus} />
            {apiStatus ? 'Connected' : 'Disconnected'}
          </div>
        </StatusRow>
      </EnvSection>
    </>
  );
};

export default Board; 