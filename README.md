# Resume

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

This will generate `Dmitri_Manajev_Resume.pdf`.

### Available Make Commands

- `make` or `make all` - Compile the resume
- `make both` - Compile Swiss and International variants
- `make cover-init` - Create a private, gitignored cover-letter fields file
- `make cover COVER_JOB=<date-company-role>` - Compile a private A4 cover letter
- `make clean` - Remove auxiliary files (`.aux`, `.log`, etc.)
- `make cleanall` - Remove all generated files including the PDF
- `make help` - Show available commands

## Automated Compilation

The resume is automatically compiled via GitHub Actions when:

- Changes are pushed to the `main` or `master` branch
- A pull request is created
- Manually triggered via workflow dispatch

The compiled PDF is available as an artifact in the GitHub Actions run.

## Cover letters

The generic template and build process are tracked in Git. Tailored application
fields and generated PDFs are excluded by `.gitignore`. See
`cover_letter/README.md` for the workflow.

## License

MIT License - See the resume source file for details.
