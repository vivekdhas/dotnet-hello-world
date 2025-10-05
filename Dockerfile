# Stage 1: Build
FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src

# Copy csproj and restore separately for better caching
COPY hello-world-api/*.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj --verbosity minimal

# Copy everything else
COPY . .
WORKDIR /src/hello-world-api

# Publish with detailed logs so Jenkins shows progress
RUN dotnet publish -c Release -o /app/out --no-restore --verbosity detailed

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Make ASP.NET Core listen on all IPs
ENV ASPNETCORE_URLS=http://0.0.0.0:80

EXPOSE 80
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
