# Makefile for compiling LaTeX resume
# Author: Dmitri Manajev

# Variables
SOURCE = dmitri_manajev.tex
OUTPUT = Dmitri_Manajev_RL_Robotics_Resume_2025.pdf
TEMP_PDF = dmitri_manajev.pdf

# LaTeX compiler
LATEX = pdflatex
LATEX_FLAGS = -interaction=nonstopmode -halt-on-error

# Default target
.PHONY: all
all: $(OUTPUT)

# Compile the resume
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

# Clean auxiliary files
.PHONY: clean
clean:
	@echo "Cleaning auxiliary files..."
	@rm -f *.aux *.log *.out *.synctex.gz *.fls *.fdb_latexmk

# Clean all generated files including PDF
.PHONY: cleanall
cleanall: clean
	@echo "Cleaning all generated files..."
	@rm -f $(OUTPUT) $(TEMP_PDF)

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all (default) - Compile the resume to $(OUTPUT)"
	@echo "  clean         - Remove auxiliary files"
	@echo "  cleanall      - Remove all generated files including PDF"
	@echo "  help          - Show this help message"

