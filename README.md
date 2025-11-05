# Dmitri Manajev - Resume

This repository contains my professional resume in LaTeX format, with automated compilation via GitHub Actions.

## Building the Resume

### Prerequisites
- LaTeX distribution (TeX Live, MiKTeX, or MacTeX)
- Make (usually pre-installed on Linux/macOS)

### Local Compilation

To compile the resume locally:

```bash
cd resume
make
```

This will generate `Dmitri_Manajev_RL_Robotics_Resume_2025.pdf`.

### Available Make Commands

- `make` or `make all` - Compile the resume
- `make clean` - Remove auxiliary files (`.aux`, `.log`, etc.)
- `make cleanall` - Remove all generated files including the PDF
- `make help` - Show available commands

## Automated Compilation

The resume is automatically compiled via GitHub Actions when:
- Changes are pushed to the `main` or `master` branch
- A pull request is created
- Manually triggered via workflow dispatch

The compiled PDF is available as an artifact in the GitHub Actions run.

## License

MIT License - See the resume source file for details.

