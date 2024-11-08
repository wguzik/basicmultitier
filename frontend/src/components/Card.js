import { useState } from 'react';
import styled from 'styled-components';
import EditCardModal from './EditCardModal';

const CardContainer = styled.div`
  position: relative;
  background: white;
  border-radius: 10px;
  padding: 16px;
  margin: 8px 0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  }
`;

const CardActions = styled.div`
  position: absolute;
  top: 8px;
  right: 8px;
  opacity: 0;
  transition: opacity 0.2s ease;
  
  ${CardContainer}:hover & {
    opacity: 1;
  }
`;

const EditButton = styled.button`
  position: absolute;
  top: 8px;
  left: 8px;
  width: 28px;
  height: 28px;
  border-radius: 6px;
  background: white;
  border: 1px solid transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #64748b;
  opacity: 0;
  
  ${CardContainer}:hover & {
    opacity: 1;
  }

  &:hover {
    background: #f0f9ff;
    color: #3b82f6;
    border-color: #bfdbfe;
  }
`;

const DeleteButton = styled.button`
  width: 28px;
  height: 28px;
  border-radius: 6px;
  background: white;
  border: 1px solid transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #64748b;

  &:hover {
    background: #fef2f2;
    color: #ef4444;
    border-color: #fecaca;
  }
`;

const Content = styled.div`
  padding: 8px 32px;  /* Added horizontal padding to accommodate buttons */

  h3 {
    color: #1e293b;
    font-size: 1.1rem;
    font-weight: 600;
    margin: 0 0 8px 0;
  }

  p {
    color: #64748b;
    font-size: 0.95rem;
    margin: 0;
    line-height: 1.5;
  }
`;

const ButtonGroup = styled.div`
  display: flex;
  justify-content: space-between;
  margin-top: 16px;
  gap: 8px;
`;

const Button = styled.button`
  padding: 6px 12px;
  border-radius: 6px;
  border: none;
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  
  ${props => {
    if (props.disabled) {
      return `
        background: #e2e8f0;
        color: #94a3b8;
        cursor: not-allowed;
      `;
    }
    
    if (props.isBackButton && props.inDoneState) {
      return `
        background: #f8fafc;
        color: #64748b;
        &:hover {
          background: #f1f5f9;
        }
      `;
    }
    
    return `
      background: #3b82f6;
      color: white;
      &:hover {
        background: #2563eb;
      }
    `;
  }}
`;

const MetaInfo = styled.div`
  font-size: 0.8rem;
  color: #94a3b8;
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid #f1f5f9;
`;

const Card = ({ todo, onMoveLeft, onMoveRight, onDelete, onEdit }) => {
  const [showEditModal, setShowEditModal] = useState(false);

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const handleDelete = async (e) => {
    e.stopPropagation();
    if (window.confirm('Are you sure you want to delete this card?')) {
      try {
        await onDelete(todo.id);
      } catch (error) {
        console.error('Failed to delete card:', error);
        alert('Failed to delete card. Please try again.');
      }
    }
  };

  const handleEdit = async (id, updates) => {
    try {
      await onEdit(id, updates);
      setShowEditModal(false);
    } catch (error) {
      console.error('Failed to edit card:', error);
      alert('Failed to edit card. Please try again.');
    }
  };

  return (
    <>
      <CardContainer>
        <EditButton 
          onClick={() => setShowEditModal(true)}
          title="Edit card"
        >
          ✎
        </EditButton>
        
        <CardActions>
          <DeleteButton 
            onClick={handleDelete}
            title="Delete card"
          >
            ×
          </DeleteButton>
        </CardActions>

        <Content>
          <h3>{todo.title}</h3>
          <p>{todo.description}</p>
          <MetaInfo>
            Last modified: {formatDate(todo.lastModifiedAt)}
          </MetaInfo>
          <ButtonGroup>
            <Button 
              onClick={onMoveLeft} 
              disabled={todo.state === 'TODO'}
              isBackButton
              inDoneState={todo.state === 'DONE'}
            >
              ← Back
            </Button>
            <Button 
              onClick={onMoveRight}
              disabled={todo.state === 'DONE'}
            >
              Move Forward →
            </Button>
          </ButtonGroup>
        </Content>
      </CardContainer>

      {showEditModal && (
        <EditCardModal
          todo={todo}
          onClose={() => setShowEditModal(false)}
          onEdit={handleEdit}
        />
      )}
    </>
  );
};

export default Card; 