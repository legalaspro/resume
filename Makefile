# Makefile for compiling LaTeX resume
# Author: Dmitri Manajev

# Variables
SOURCE = dmitri_manajev.tex
OUTPUT = Dmitri_Manajev_Resume.pdf
OUTPUT_SWISS = Dmitri_Manajev_Resume_Swiss.pdf
OUTPUT_INTL = Dmitri_Manajev_Resume_International.pdf
TEMP_PDF = dmitri_manajev.pdf
TEMP_JOB = $(basename $(TEMP_PDF))
SWISS_INPUT = \AtBeginDocument{\swissversiontrue}\input{$(SOURCE)}
INTL_INPUT = \AtBeginDocument{\swissversionfalse}\input{$(SOURCE)}

# Cover letter variables (tailored fields and outputs stay gitignored)
COVER_FIELDS ?= private/cover_letters/current/fields.tex
COVER_JOB ?= current
COVER_EXAMPLE = cover_letter/fields.example.tex
COVER_SCRIPT = scripts/build_cover_letter.sh
PRIVATE_COVER_ROOT := $(abspath private/cover_letters)
COVER_FIELDS_PATH = $(abspath $(COVER_FIELDS))

# LaTeX compiler
LATEX = pdflatex
LATEX_FLAGS = -interaction=nonstopmode -halt-on-error

# Default target (builds current version as-is)
.PHONY: all
all: $(OUTPUT)

# Compile the resume (uses current settings in .tex file)
$(OUTPUT): $(SOURCE)
	@echo "Compiling $(SOURCE)..."
	$(LATEX) $(LATEX_FLAGS) $(SOURCE)
	$(LATEX) $(LATEX_FLAGS) $(SOURCE)
	@if [ -f $(TEMP_PDF) ]; then \
		mv $(TEMP_PDF) $(OUTPUT); \
		echo "Successfully created $(OUTPUT)"; \
	else \
		echo "Error: PDF compilation failed"; \
		exit 1; \
	fi

# Build Swiss version (with permit)
.PHONY: swiss
swiss:
	@echo "Building Swiss version (with permit)..."
	@$(LATEX) $(LATEX_FLAGS) -jobname=$(TEMP_JOB) '$(SWISS_INPUT)'
	@$(LATEX) $(LATEX_FLAGS) -jobname=$(TEMP_JOB) '$(SWISS_INPUT)'
	@if [ -f $(TEMP_PDF) ]; then \
		mv $(TEMP_PDF) $(OUTPUT_SWISS); \
		echo "Successfully created $(OUTPUT_SWISS)"; \
	else \
		echo "Error: PDF compilation failed"; \
		exit 1; \
	fi

# Build International version (without permit)
.PHONY: international
international:
	@echo "Building International version (without permit)..."
	@$(LATEX) $(LATEX_FLAGS) -jobname=$(TEMP_JOB) '$(INTL_INPUT)'
	@$(LATEX) $(LATEX_FLAGS) -jobname=$(TEMP_JOB) '$(INTL_INPUT)'
	@if [ -f $(TEMP_PDF) ]; then \
		mv $(TEMP_PDF) $(OUTPUT_INTL); \
		echo "Successfully created $(OUTPUT_INTL)"; \
	else \
		echo "Error: PDF compilation failed"; \
		exit 1; \
	fi

# Build both versions
.PHONY: both
both: swiss international
	@echo "Successfully built both versions!"

# Create a private fields file without overwriting an existing application
.PHONY: cover-init
cover-init:
	@case "$(COVER_FIELDS_PATH)" in \
		"$(PRIVATE_COVER_ROOT)"/*) ;; \
		*) echo "Error: COVER_FIELDS must stay under private/cover_letters/" >&2; exit 2 ;; \
	esac
	@if [ -e "$(COVER_FIELDS)" ]; then \
		echo "Keeping existing $(COVER_FIELDS)"; \
	else \
		mkdir -p "$(dir $(COVER_FIELDS))"; \
		cp "$(COVER_EXAMPLE)" "$(COVER_FIELDS)"; \
		echo "Created private fields at $(COVER_FIELDS)"; \
	fi

# Compile a private, tailored cover letter into an ignored output directory
.PHONY: cover
cover:
	@bash "$(COVER_SCRIPT)" "$(COVER_FIELDS)" "$(COVER_JOB)"

# Clean auxiliary files
.PHONY: clean
clean:
	@echo "Cleaning auxiliary files..."
	@rm -f *.aux *.log *.out *.synctex.gz *.fls *.fdb_latexmk

# Clean all generated files including PDF
.PHONY: cleanall
cleanall: clean
	@echo "Cleaning all generated files..."
	@rm -f $(OUTPUT) $(OUTPUT_SWISS) $(OUTPUT_INTL) $(TEMP_PDF)

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all (default)   - Compile the resume with current settings"
	@echo "  swiss           - Build Swiss version (with work permit)"
	@echo "  international   - Build International version (without permit)"
	@echo "  both            - Build both Swiss and International versions"
	@echo "  cover-init      - Create a gitignored cover-letter fields file"
	@echo "  cover           - Build an A4 cover letter from private fields"
	@echo "  clean           - Remove auxiliary files"
	@echo "  cleanall        - Remove all generated files including PDFs"
	@echo "  help            - Show this help message"
