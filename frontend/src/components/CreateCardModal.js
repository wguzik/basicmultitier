import styled from 'styled-components';
import { useState } from 'react';

const ModalOverlay = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(5px);
`;

const ModalContent = styled.div`
  background: white;
  padding: 32px;
  border-radius: 12px;
  width: 100%;
  max-width: 600px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
`;

const ModalHeader = styled.div`
  text-align: center;
  margin-bottom: 32px;
  padding-bottom: 16px;
  border-bottom: 1px solid #eee;
  
  h2 {
    font-size: 1.8rem;
    color: #2c3e50;
    margin: 0;
    margin-bottom: 8px;
  }
`;

const Form = styled.form`
  display: flex;
  flex-direction: column;
  gap: 24px;
  width: 100%;
`;

const FormGroup = styled.div`
  display: flex;
  flex-direction: column;
  gap: 8px;
  width: 100%;
`;

const Label = styled.label`
  font-weight: 600;
  color: #2c3e50;
  font-size: 1rem;
  margin-bottom: 4px;

  span {
    color: #e74c3c;
    margin-left: 4px;
  }
`;

const Input = styled.input`
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.2s ease;
  box-sizing: border-box;

  &:focus {
    outline: none;
    border-color: #2ecc71;
    box-shadow: 0 0 0 3px rgba(46, 204, 113, 0.1);
  }

  &::placeholder {
    color: #bdc3c7;
  }
`;

const Textarea = styled.textarea`
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 1rem;
  min-height: 120px;
  resize: vertical;
  transition: all 0.2s ease;
  box-sizing: border-box;
  font-family: inherit;

  &:focus {
    outline: none;
    border-color: #2ecc71;
    box-shadow: 0 0 0 3px rgba(46, 204, 113, 0.1);
  }

  &::placeholder {
    color: #bdc3c7;
  }
`;

const ButtonGroup = styled.div`
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #eee;
`;

const Button = styled.button`
  padding: 12px 24px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 600;
  transition: all 0.2s ease;
  
  &.cancel {
    background: #f1f1f1;
    color: #333;
  }
  
  &.create {
    background: #2ecc71;
    color: white;
    font-weight: bold;
  }
`;

const CreateCardModal = ({ onClose, onCreate }) => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    onCreate(title, description);
    onClose();
  };

  return (
    <ModalOverlay onClick={onClose}>
      <ModalContent onClick={e => e.stopPropagation()}>
        <ModalHeader>
          <h2>Create New Card</h2>
        </ModalHeader>
        <Form onSubmit={handleSubmit}>
          <FormGroup>
            <Label htmlFor="title">Title</Label>
            <Input
              id="title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Enter card title"
              required
            />
          </FormGroup>
          <FormGroup>
            <Label htmlFor="description">Description</Label>
            <Textarea
              id="description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Enter card description"
            />
          </FormGroup>
          <ButtonGroup>
            <Button type="button" className="cancel" onClick={onClose}>
              Cancel
            </Button>
            <Button type="submit" className="create">
              Create Card
            </Button>
          </ButtonGroup>
        </Form>
      </ModalContent>
    </ModalOverlay>
  );
};

export default CreateCardModal; 