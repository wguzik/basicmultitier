import { useState, useEffect } from 'react';
import styled from 'styled-components';
import Column from './Column';
import { todoService } from '../services/todoService';
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

const Board = ({ refreshTrigger }) => {
  const [todos, setTodos] = useState([]);

  useEffect(() => {
    const fetchTodos = async () => {
      const data = await todoService.getAllTodos();
      setTodos(data);
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
  );
};

export default Board; 