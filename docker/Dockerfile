# Specify the parent image from which we build
FROM mcr.microsoft.com/powershell:7.4-ubuntu-22.04

# Set the working directory
WORKDIR /tmp/pschristmastree

COPY PSChristmasTree/ ./PSChristmasTree/

RUN mkdir -p /usr/local/share/powershell/Modules/PSChristmasTree && \
	cp -r ./PSChristmasTree/* /usr/local/share/powershell/Modules/PSChristmasTree/ && \
	rm -rf /tmp/pschristmastree/*

HEALTHCHECK --interval=30s --timeout=10s --retries=1 \
	CMD pwsh -NoProfile -Command "Import-Module PSChristmasTree; Get-PSChristmasTreeConfig" || exit 1

# Run the application
CMD ["pwsh"]