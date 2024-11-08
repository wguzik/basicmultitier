import { useState } from 'react';
import Board from './components/Board';
import CreateCardModal from './components/CreateCardModal';
import styled from 'styled-components';
import { todoService } from './services/todoService';

const AppContainer = styled.div`
  min-height: 100vh;
  background: #f8fafc;
`;

const AppContent = styled.div`
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
`;

const Header = styled.header`
  background: white;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  padding: 16px 0;
  margin-bottom: 32px;
`;

const HeaderContent = styled.div`
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const Title = styled.h1`
  color: #1e293b;
  margin: 0;
  font-size: 1.8rem;
  font-weight: 600;
`;

const CreateButton = styled.button`
  padding: 10px 20px;
  background: #3b82f6;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease-in-out;
  display: flex;
  align-items: center;
  gap: 8px;

  &:hover {
    background: #2563eb;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);
  }

  &:active {
    transform: translateY(0);
  }

  svg {
    width: 16px;
    height: 16px;
  }
`;

function App() {
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [refreshTrigger, setRefreshTrigger] = useState(0);

  const handleCreateCard = async (title, description) => {
    try {
      await todoService.createTodo(title, description);
      setRefreshTrigger(prev => prev + 1);
    } catch (error) {
      console.error('Failed to create card:', error);
      alert('Failed to create card. Please try again.');
    }
  };

  return (
    <AppContainer>
      <Header>
        <HeaderContent>
          <Title>Task Board</Title>
          <CreateButton onClick={() => setShowCreateModal(true)}>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
            </svg>
            New Task
          </CreateButton>
        </HeaderContent>
      </Header>

      <AppContent>
        <Board refreshTrigger={refreshTrigger} />
      </AppContent>
      
      {showCreateModal && (
        <CreateCardModal
          onClose={() => setShowCreateModal(false)}
          onCreate={handleCreateCard}
        />
      )}
    </AppContainer>
  );
}

export default App;
