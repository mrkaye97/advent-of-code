# Variables
MIX=mix

# Default target: Show usage
help:
	@echo "Usage:"
	@echo "  make new YEAR=YYYY DAY=DD     # Generate a new solution template for the given year and day"
	@echo "  make run YEAR=YYYY DAY=DD     # Run the solution for the given year and day"
	@echo "  make fmt                      # Format the codebase"

# Ensure YEAR and DAY are defined
check-variables:
	@if [ -z "$(YEAR)" ] || [ -z "$(DAY)" ]; then \
		echo "Error: YEAR and DAY must be provided. Usage: make <target> YEAR=YYYY DAY=DD"; \
		exit 1; \
	fi

# Generate a new solution template
new: check-variables
	@$(MIX) solution.new --year $(YEAR) --day $(DAY)

# Run the solution
run: check-variables
	@$(MIX) run lib/solutions/$(YEAR)/$(DAY).exs

# Format the codebase
fmt:
	@$(MIX) format
