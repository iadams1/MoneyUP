The **api/** folder contains all HTTP-facing code.

It should only do three things:

1. Accept requests
2. Validate data
3. Call services

It should NOT contain:
- database logic
- AI logic
- business logic

Those go in:
- services/
- database/
- models/