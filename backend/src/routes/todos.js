const express = require('express');
const { PrismaClient } = require('@prisma/client');

const router = express.Router();
const prisma = new PrismaClient();

// Get all todos
router.get('/todos', async (req, res) => {
  try {
    const { state } = req.query;
    const todos = await prisma.todo.findMany({
      where: {
        state: state || undefined
      },
      orderBy: {
        createdAt: 'desc'
      }
    });
    res.json(todos);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch todos' });
  }
});

// Get single todo
router.get('/todos/:id', async (req, res) => {
  try {
    const todo = await prisma.todo.findUnique({
      where: { id: Number(req.params.id) },
    });
    if (!todo) {
      return res.status(404).json({ error: 'Todo not found' });
    }
    res.json(todo);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch todo' });
  }
});

// Create todo
router.post('/todos', async (req, res) => {
  try {
    const { title, description } = req.body;
    const todo = await prisma.todo.create({
      data: {
        title,
        description,
      },
    });
    res.status(201).json(todo);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create todo' });
  }
});

// Update todo
router.put('/todos/:id', async (req, res) => {
  try {
    const { title, description, state } = req.body;
    const todo = await prisma.todo.update({
      where: { id: Number(req.params.id) },
      data: {
        title,
        description,
        state,
      },
    });
    res.json(todo);
  } catch (error) {
    res.status(500).json({ error: 'Failed to update todo' });
  }
});

// Delete todo
router.delete('/todos/:id', async (req, res) => {
  try {
    await prisma.todo.delete({
      where: { id: Number(req.params.id) },
    });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Failed to delete todo' });
  }
});

// Patch todo
router.patch('/todos/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { state } = req.body;
    
    const updatedTodo = await prisma.todo.update({
      where: { id: parseInt(id) },
      data: { state }
    });
    
    res.json(updatedTodo);
  } catch (error) {
    res.status(500).json({ error: 'Failed to update todo' });
  }
});

module.exports = router; 