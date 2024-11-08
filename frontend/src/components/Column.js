import styled from 'styled-components';
import Card from './Card';

const ColumnContainer = styled.div`
  background: #f1f5f9;
  border-radius: 12px;
  padding: 16px;
  min-height: 500px;
`;

const ColumnTitle = styled.h2`
  color: #475569;
  font-size: 1.1rem;
  font-weight: 600;
  margin: 0 0 16px 0;
  padding: 0 8px;
  display: flex;
  align-items: center;
  gap: 8px;

  &::before {
    content: '';
    display: inline-block;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: ${props => {
      switch (props.title) {
        case 'Todo': return '#ef4444';
        case 'In Progress': return '#f59e0b';
        case 'Done': return '#22c55e';
        default: return '#94a3b8';
      }
    }};
  }
`;

const Column = ({ title, todos, onMoveLeft, onMoveRight, onDelete, onEdit }) => {
  return (
    <ColumnContainer>
      <ColumnTitle>{title}</ColumnTitle>
      {todos.map(todo => (
        <Card
          key={todo.id}
          todo={todo}
          onMoveLeft={onMoveLeft && (() => onMoveLeft(todo))}
          onMoveRight={onMoveRight && (() => onMoveRight(todo))}
          onDelete={onDelete}
          onEdit={onEdit}
        />
      ))}
    </ColumnContainer>
  );
};

export default Column; 