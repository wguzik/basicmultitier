const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // Clear existing data
  await prisma.todo.deleteMany({});

  // Create sample todos
  const todos = [
    {
      title: 'Create backend API',
      description: 'Implement REST API endpoints',
      state: 'TODO',
    },
    {
      title: 'Design database schema',
      description: 'Create initial database structure',
      state: 'IN_PROGRESS',
    },
    {
      title: 'Setup project',
      description: 'Initialize project with necessary dependencies',
      state: 'DONE',
    },
  ];

  for (const todo of todos) {
    await prisma.todo.create({
      data: todo,
    });
  }

  console.log('Seed data created successfully');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  }); 