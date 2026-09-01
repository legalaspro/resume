#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
private_root="$repo_dir/private/cover_letters"

fields_arg=${1:-private/cover_letters/current/fields.tex}
job_slug=${2:-current}

case "$job_slug" in
  ""|*[!A-Za-z0-9._-]*)
    printf 'Error: job slug may contain only letters, numbers, dots, underscores, and hyphens.\n' >&2
    exit 2
    ;;
esac

case "$fields_arg" in
  /*) fields_candidate=$fields_arg ;;
  *) fields_candidate="$repo_dir/$fields_arg" ;;
esac

if [ ! -f "$fields_candidate" ]; then
  printf 'Error: private fields file not found: %s\n' "$fields_candidate" >&2
  printf 'Create one with: make cover-init COVER_FIELDS=%s\n' "$fields_arg" >&2
  exit 2
fi

fields_dir=$(CDPATH= cd -- "$(dirname -- "$fields_candidate")" && pwd -P)
fields_file="$fields_dir/$(basename -- "$fields_candidate")"

case "$fields_file" in
  "$private_root"/*) ;;
  *)
    printf 'Error: tailored fields must stay under the ignored directory %s\n' "$private_root" >&2
    exit 2
    ;;
esac

if grep -Eq 'Applicant Name|Example Company|Example Position|20XX|TODO' "$fields_file"; then
  printf 'Error: replace all example/placeholder values before building.\n' >&2
  exit 2
fi

if [ -n "${LATEX:-}" ]; then
  latex_bin=$LATEX
elif command -v pdflatex >/dev/null 2>&1; then
  latex_bin=$(command -v pdflatex)
elif [ -x /Library/TeX/texbin/pdflatex ]; then
  latex_bin=/Library/TeX/texbin/pdflatex
else
  printf 'Error: pdflatex was not found.\n' >&2
  exit 2
fi

output_dir="$private_root/generated/$job_slug"
mkdir -p "$output_dir"
pdf_path="$output_dir/cover_letter.pdf"
tex_entry="\\def\\coverletterfields{$fields_file}\\input{cover_letter/template.tex}"

run_latex() {
  pass=$1
  if ! "$latex_bin" -interaction=nonstopmode -halt-on-error \
      -output-directory="$output_dir" -jobname=cover_letter \
      "$tex_entry" >"$output_dir/build-pass-$pass.log" 2>&1; then
    tail -50 "$output_dir/build-pass-$pass.log" >&2
    return 1
  fi
}

cd "$repo_dir"
run_latex 1
run_latex 2

if [ ! -f "$pdf_path" ]; then
  printf 'Error: expected PDF was not created: %s\n' "$pdf_path" >&2
  exit 1
fi

if command -v pdfinfo >/dev/null 2>&1; then
  pages=$(pdfinfo "$pdf_path" | awk '/^Pages:/ {print $2}')
  page_size=$(pdfinfo "$pdf_path" | awk -F': +' '/^Page size:/ {print $2}')
  if [ "$pages" != "1" ]; then
    printf 'Error: cover letter must be one page; generated %s pages.\n' "$pages" >&2
    exit 1
  fi
  case "$page_size" in
    *A4*) ;;
    *)
      printf 'Error: expected A4 output; generated page size is %s.\n' "$page_size" >&2
      exit 1
      ;;
  esac
fi

printf 'Created private cover letter: %s\n' "$pdf_path"
