---
name: py-init
description: Scaffold a new Python project with modern tooling
user-invocable: true
---

# Python Project Initializer

This command creates a new Python project with modern tooling and best practices.

## Usage

```bash
/py-init project-name
```

## What It Creates

### Project Structure
```
project-name/
├── pyproject.toml          # Modern Python project config
├── README.md              # Project documentation
├── .gitignore             # Git ignore rules
├── src/                   # Source code
│   └── project_name/      # Package structure
│       ├── __init__.py
│       └── main.py
├── tests/                 # Test files
│   └── test_main.py
└── scripts/               # Utility scripts
```

### Configuration Files

**pyproject.toml** - Modern Python project configuration:
```toml
[build-system]
requires = ["setuptools", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "project-name"
version = "0.1.0"
description = "A new Python project"
authors = [{name = "Your Name", email = "your.email@example.com"}]
readme = "README.md"
requires-python = ">=3.12"
license = {text = "MIT"}
classifiers = [
    "Development Status :: 3 - Alpha",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.12",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0.0",
    "pytest-cov>=4.1.0",
    "pytest-asyncio>=0.23.0",
    "hypothesis>=6.88.0",
    "mypy>=1.8.0",
    "ruff>=0.1.14",
    "black>=23.12.0",
    "safety>=2.4.0",
    "pytest-mock>=3.12.0",
    "pytest-benchmark>=4.0.0",
]
test = [
    "pytest>=8.0.0",
    "pytest-cov>=4.1.0",
    "hypothesis>=6.88.0",
    "pytest-asyncio>=0.23.0",
]

[project.urls]
Homepage = "https://github.com/yourusername/project-name"
Repository = "https://github.com/yourusername/project-name"

[tool.ruff]
line-length = 88
target-version = "py312"
select = ["E", "F", "W", "I", "N", "B", "A", "C4", "UP", "RUF"]
ignore = ["E501"]
extend-ignore = [
    "PLR",  # Design related pylint codes
]

[tool.mypy]
python_version = "3.12"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true
strict_equality = true
disallow_any_generics = true
disallow_subclassing_any = true
disallow_untyped_calls = true
disallow_untyped_decorators = true
disallow_untyped_imports = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = "-ra -q --strict-markers --strict-config --tb=short"
asyncio_mode = "auto"

[tool.coverage.run]
source = ["src"]
omit = [
    "*/tests/*",
    "*/test_*",
    "*/conftest.py",
    "*/setup.py",
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "if self.debug:",
    "raise AssertionError",
    "raise NotImplementedError",
    "if 0:",
    "if __name__ == .__main__.:",
]
```

**.gitignore** - Standard Python git ignore:
```gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
.python-version

# pipenv
Pipfile.lock

# PEP 582
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/
```

**README.md** - Basic project documentation:
```markdown
# Project Name

A brief description of your Python project.

## Installation

```bash
git clone https://github.com/yourusername/project-name.git
cd project-name
uv sync
```

## Usage

```bash
uv run python -m project_name
```

## Development

```bash
# Install development dependencies
uv sync --dev

# Run tests
uv run pytest

# Run linting
uv run ruff check src/

# Run type checking
uv run mypy src/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Run the test suite
6. Submit a pull request

## License

This project is licensed under the MIT License.
```

## Development Workflow

After initialization, you can:

```bash
# Navigate to project
cd project-name

# Install dependencies
uv sync

# Run tests
uv run pytest

# Check code quality
uv run ruff check src/
uv run mypy src/

# Format code
uv run black src/
```

## Example Usage

```python
# src/project_name/main.py

def main() -> None:
    """Main entry point for the application."""
    print("\u001b[32mHello, Python Developer!\u001b[0m")
    print("\u001b[34mProject initialized successfully.\u001b[0m")

if __name__ == "__main__":
    main()
```

## Testing the Project

```python
# tests/test_main.py

from project_name.main import main

def test_main(capsys):
    main()
    captured = capsys.readouterr()
    assert "Hello, Python Developer!" in captured.out
```

## Next Steps

1. **Add dependencies**: `uv add requests pandas`
2. **Add dev dependencies**: `uv add --dev pytest black mypy`
3. **Configure your editor**: Set up LSP with `basedpyright` or your existing `pyright-lsp`
4. **Set up git**: `git init && git add . && git commit -m "Initial commit"`
5. **Run initial tests**: `uv run pytest --cov=src`

---

## Integration with Other Skills

This command works with:
- `python-expert` for advanced Python guidance
- `dependency-manager` for package management
- `code-quality` for maintaining code standards

Use `/py-init` whenever you need to start a new Python project with modern tooling and best practices.