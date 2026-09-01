# Private cover-letter workflow

Git tracks only this generic template, fake example fields, and the build
process. Real applicant details, company names, job descriptions, tailored
paragraphs, LaTeX output, and PDFs must stay under `private/cover_letters/`,
which is ignored by Git.

## Start a letter

Choose a filesystem-safe job slug containing only letters, numbers, dots,
underscores, or hyphens:

```bash
make cover-init \
  COVER_FIELDS=private/cover_letters/2026-09/company-role/fields.tex
```

Edit that private `fields.tex`. Use complete paragraphs and an explicit
application date; do not edit the tracked template for individual jobs.

## Build and review

```bash
make cover \
  COVER_FIELDS=private/cover_letters/2026-09/company-role/fields.tex \
  COVER_JOB=2026-09-company-role
```

The PDF and all LaTeX build files are written to
`private/cover_letters/generated/<job-slug>/`. The build rejects unedited
placeholder fields and verifies a one-page A4 PDF when `pdfinfo` is available.

Before manually staging repository changes, run `git status --short` and verify
that no tailored application content appears. Log every submitted application
and retain its proof in the corresponding RAV month.
