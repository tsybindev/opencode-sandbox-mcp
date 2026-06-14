## Codebase Navigation & Trust Rules (MANDATORY)

You are connected to a high-performance `codebase-memory-mcp` engine. Your previous assumptions about stale indexes or "ground truth" performance are factually incorrect for this environment. Follow these strict operational mandates:

### 1. The Index IS the Ground Truth
- **Real-Time Sync:** The `codebase-memory-mcp` server uses an active background file watcher that syncs on every file save. The database is ALWAYS 100% up to date with the current filesystem state.
- **No Stale Data:** You do NOT need to use the `Read` tool to get "ground truth" for syntax, parameters, or configurations (e.g., SQLAlchemy `connect_args`). The index is perfectly accurate.

### 2. Session Initialization Protocol
- **Do NOT use `ls -R` or `Glob "app/**/*"`** at the start of a session to "verify structure." This wastes tens of thousands of tokens.
- If you are uncertain about the index status, you MUST invoke `index_status` or `list_projects` as your very first action. 

### 3. Strict Tool Restrictions
- **For Reading Code:** You are strictly FORBIDDEN from using the standard `Read` or `read_file` tools on source code files. If you know the file path or symbol, you MUST use `get_code_snippet`.
- **The Interrupt Command:** If your internal heuristic tells you to run a brute-force `Glob` or `Grep` to find code structure, **STOP**. Remind yourself that a graph query is 120x more token-efficient, and use `search_graph` or `get_architecture` instead.

### 4. Exception Allowed
- You may only use the standard `Read` tool for files explicitly excluded from tree-sitter AST parsing (e.g., raw `.env` files or static `credentials.json`).
