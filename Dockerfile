# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY hello-world-api/*.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj

COPY . .
WORKDIR /src/hello-world-api
RUN dotnet publish -c Release -o /app/out --no-restore

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

ENV ASPNETCORE_URLS=http://0.0.0.0:80
EXPOSE 80
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
