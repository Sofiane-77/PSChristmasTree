# Specify the parent image from which we build
FROM mcr.microsoft.com/powershell:latest

# Set the working directory
WORKDIR /app

RUN apt-get -yq update && \
    apt-get -yq install git && \
	apt-get -yq clean
	
RUN git clone https://github.com/Sofiane-77/PSChristmasTree.git /app && \
	mkdir -p /usr/local/share/powershell/Modules/ && \
	cp -r /app/PSChristmasTree /usr/local/share/powershell/Modules/ && \
	rm -rf /app/*

# Run the application
#CMD ["pwsh", "-Command", "git clone https://github.com/Sofiane-77/PSChristmasTree.git .; Import-Module ./PSChristmasTree/PSChristmasTree.psd1 -force; Show-PSChristmasTree"]
#CMD ["pwsh", "-Command", "git clone https://github.com/Sofiane-77/PSChristmasTree.git .; Import-Module ./PSChristmasTree/PSChristmasTree.psd1 -force;"]
CMD ["pwsh"]