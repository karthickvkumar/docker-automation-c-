# Use the Windows Server Core as the base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Use the official .NET runtime image as the base image
FROM mcr.microsoft.com/dotnet/runtime:5.0

# Start with a base image that includes the .NET Framework and other dependencies
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build

# Set the working directory in the container
WORKDIR /app

# Download and install Chocolatey
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Chrome using Chocolatey
RUN choco install -y googlechrome

# Copy the published C# Selenium test project to the container
COPY . .

# Build your test project
RUN msbuild /t:Clean
RUN nuget restore
RUN msbuild /p:Configuration=Release

# Set the MOZ_REMOTE_SETTINGS_DEVTOOLS environment variable
# ENV MOZ_REMOTE_SETTINGS_DEVTOOLS=1

# # Download the Firefox installer

# RUN Invoke-WebRequest -Uri 'https://download-installer.cdn.mozilla.net/pub/firefox/releases/112.0/win64/en-US/Firefox%20Setup%20112.0.exe' -OutFile 'C:\FirefoxSetup.exe' ; \
#     Start-Process -Wait -FilePath 'C:\FirefoxSetup.exe' -ArgumentList '/S' ; \
#     Remove-Item 'C:\FirefoxSetup.exe' -Force

# RUN Invoke-WebRequest -Uri 'https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi' -OutFile 'C:/ChromeInstaller/GoogleChromeStandaloneEnterprise64.msi' ; \
#     Start-Process -Wait -FilePath 'C:\ChromeInstaller\GoogleChromeStandaloneEnterprise64.msi' -ArgumentList '/S' ; \
#     Remove-Item 'C:\ChromeInstaller\GoogleChromeStandaloneEnterprise64.msi' -Force
# Install Chrome

# # Download Google Chrome Installer
# ADD https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi C:/ChromeInstaller/GoogleChromeStandaloneEnterprise64.msi

# # Install Google Chrome
# RUN msiexec /i C:\ChromeInstaller\GoogleChromeStandaloneEnterprise64.msi /qn

# # Cleanup
# RUN del C:\ChromeInstaller\GoogleChromeStandaloneEnterprise64.msi

# ENV vstest.console.exe=C:\app\packages\Microsoft.TestPlatform.17.7.2\tools\net462\Common7\IDE\Extensions\TestPlatform

# Run the tests with vstest.console
ENTRYPOINT ["dotnet", "test", "bin/Release/AutomationDocker.dll", "--logger", "html"]

# Create a directory inside the container
# RUN mkdir /app/data

# COPY ./TestResults /app/data

# RUN dir

# Expose the volume
# VOLUME [ "/TestResults" ]

#Build the Docker Image
# docker build -t automation-docker .
#RUN the Docker Image
# docker run automation-docker

# docker run -p 8080:80 -v /path/on/host:/usr/share/nginx/html/myapp my_nginx_image


# docker run -v /TestResults:/app/data automation-docker 


# C:\app\packages\Microsoft.TestPlatform.17.7.2\tools\net462\Common7\IDE\Extensions\TestPlatform

# docker run -v C:\Users\Karthick:C:\app\TestResults -p 8080:80 -it automation-docker
