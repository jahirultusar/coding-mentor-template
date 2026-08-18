# 🎓 Coding Mentor

**Coding Mentor** is a self-directed coding practice framework powered by **Claude Code**. It operates as an automated mentor or a hackathon manager by analyzing your local repository, tracking your long-term progress, and dynamically generating coding challenges tailored specifically to your weaknesses and goals.

---

### ⚠️ Disclaimer


**Educational Purposes Only!** 
> This repository and its contents are provided strictly for educational, research, and informational purposes. 

---

## 💻 How to Use This Template

This repository is configured as a **GitHub Repository Template**. Do not fork or clone this repository directly if you want to start your own clean workspace.

1. Click the green **"Use this template"** button at the top of this page.
2. Select **"Create a new repository"**.
3. Choose your own repository name and visibility (Private/Public).
4. Clone *your new repository* to your local machine.

---

## 🛠️ Prerequisites

Before getting started, please make sure you have the following installed on your host machine:
* **Docker & Docker Compose** (To isolate and run your coding environments)

> **Note**: You don't need Claude Code installed on your host to use this repo — the Docker image builds it in during docker compose up -d --build, so it's already present by the time you exec into the container.
---

## 🚀 Quick Start

### 1. Set your host UID/GID (one-time, per machine)

The container runs as your own user (not root) so that files it creates are owned by you on the host, not root. Add this to your `~/.bashrc` (or `~/.zshrc`), then reload your shell:

```bash
export UID
export GID=$(id -g)
```

This step matters — without it, Docker falls back to default IDs and files created inside the container may end up owned by a different user than you on the host, which can block your editor from saving them.

### 2. Spin up the Environment
```bash
# Build and start the container in the background
docker compose up -d --build

# Enter the container's interactive shell
docker compose exec mentor bash
```

### 3. Start a Session
Launch Claude Code within this repository directory inside docker:
```bash
claude
```
Once the CLI initializes, prompt your mentor to begin:
> *"Give me a new challenge based on my current track."*  
> OR  
> *"What should I work on today?"*

---

## 🏗️ How It Works

The framework relies on a predictable file structure that Claude Code reads and updates continuously to maintain state between your sessions:

```text
├── CLAUDE.md          # Global instructions guiding Claude to act as a mentor
├── PROGRESS.md        # The running ledger of skills practiced, strengths, and weaknesses
├── challenges/        # Active challenge workspace (one directory per challenge)
└── archive/           # Completed and reviewed challenges moved here for storage
```

### Component Breakdown
* **`CLAUDE.md`**: The brain of the setup. It contains the system prompt overrides instructing Claude Code how to behave, how to evaluate your code, and how to structure challenges.
* **`PROGRESS.md`**: The state machine. Claude dynamically updates this file after reviewing your submissions to log completed tasks, track metric scores, and highlight areas needing improvement.
* **`challenges/`**: Your active sandbox. Claude creates scoped project files here for you to solve.
* **`archive/`**: Your portfolio. Once a challenge is marked as complete and reviewed, Claude archives it to keep your active workspace clean.

---

## 🔄 Typical Workflow Loop

```mermaid
graph TD
    A[Start Claude Code] --> B[Ask for a Challenge]
    B --> C[Claude reads PROGRESS.md & creates challenge in challenges/]
    C --> D[You write code & test your solution]
    D --> E[Claude reviews, grades, and updates PROGRESS.md]
    E --> F[Claude archives the completed challenge]
```

1. **Request:** Ask Claude for a tailored task.
2. **Execute:** Build your solution inside the generated `challenges/` subfolder.
3. **Review:** Ask Claude to evaluate your code against the challenge criteria.
4. **Iterate:** Address feedback until Claude approves the solution.
5. **Archive:** Claude updates `PROGRESS.md` and moves the workspace folder into `archive/`.

---

## 🐛 Troubleshooting

### "Insufficient permissions" / editor asks to save as sudo

This happens when files inside `challenges/` or `archive/` are owned by `root` instead of your host user. It's usually caused by one of:

* You skipped the UID/GID export step above before first building the container.
* You ran `docker compose exec mentor bash` on an older build of this container, back when it ran as `root` by default.

**Fix:**
```bash
# From your host (not inside the container), reclaim ownership:
sudo chown -R $USER:$USER /path/to/your/coding-mentor

# Make sure UID/GID are exported (see Quick Start step 1), then rebuild:
docker compose down
docker compose up -d --build
```

### Editing on host vs. inside the container

If your editor is attached directly to the **host** filesystem (not the container itself, e.g. via SSH/Remote to your machine rather than Dev Containers), you can still edit files fine — the bind mount keeps host and container in sync. But running/debugging code from the host side will use your **host's** Python and won't have access to the packages installed in the container (`pytest`, `ruff`, etc.). For now, run and test your solutions from inside the container shell:
```bash
docker compose exec mentor bash
pytest challenges/<challenge-folder>/solution/test_solution.py -v
```
If you want your editor's Run/Debug buttons to use the container's environment directly, look into the **Dev Containers** extension (VS Code) — that's an optional upgrade once the basic loop is working smoothly.

---

## 🤝 Contributing

Contributions are welcome to help expand the default project templates and mentoring heuristics! 

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

Happy learning :)
