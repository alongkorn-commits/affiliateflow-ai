# ADR-0001: Start with a modular monolith

- Status: Accepted
- Context: MVP needs rapid iteration and strong transactional consistency.
- Decision: Laravel modular monolith with separate queue/media workers. Paperclip remains a separate orchestration service.
- Consequences: simpler deployment and transactions; modules must enforce boundaries to avoid a monolith becoming tangled. Extract services only when scale or operational needs justify it.
