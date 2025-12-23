# Makefile for compiling LaTeX resume
# Author: Dmitri Manajev

# Variables
SOURCE = dmitri_manajev.tex
OUTPUT = Dmitri_Manajev_RL_Robotics_Resume_2025.pdf
OUTPUT_SWISS = Dmitri_Manajev_RL_Robotics_Resume_2025_Swiss.pdf
OUTPUT_INTL = Dmitri_Manajev_RL_Robotics_Resume_2025_International.pdf
TEMP_PDF = dmitri_manajev.pdf

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
	@sed -i.bak 's/% \\swissversiontrue/\\swissversiontrue/' $(SOURCE)
	@sed -i.bak 's/\\swissversionfalse/% \\swissversionfalse/' $(SOURCE)
	@$(LATEX) $(LATEX_FLAGS) $(SOURCE)
	@$(LATEX) $(LATEX_FLAGS) $(SOURCE)
	@if [ -f $(TEMP_PDF) ]; then \
		mv $(TEMP_PDF) $(OUTPUT_SWISS); \
		echo "Successfully created $(OUTPUT_SWISS)"; \
	else \
		echo "Error: PDF compilation failed"; \
		exit 1; \
	fi
	@mv $(SOURCE).bak $(SOURCE)

# Build International version (without permit)
.PHONY: international
international:
	@echo "Building International version (without permit)..."
	@sed -i.bak 's/\\swissversiontrue/% \\swissversiontrue/' $(SOURCE)
	@sed -i.bak 's/% \\swissversionfalse/\\swissversionfalse/' $(SOURCE)
	@$(LATEX) $(LATEX_FLAGS) $(SOURCE)
	@$(LATEX) $(LATEX_FLAGS) $(SOURCE)
	@if [ -f $(TEMP_PDF) ]; then \
		mv $(TEMP_PDF) $(OUTPUT_INTL); \
		echo "Successfully created $(OUTPUT_INTL)"; \
	else \
		echo "Error: PDF compilation failed"; \
		exit 1; \
	fi
	@mv $(SOURCE).bak $(SOURCE)

# Build both versions
.PHONY: both
both: swiss international
	@echo "Successfully built both versions!"

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
	@echo "  clean           - Remove auxiliary files"
	@echo "  cleanall        - Remove all generated files including PDFs"
	@echo "  help            - Show this help message"

