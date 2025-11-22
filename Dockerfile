# Build stage
FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY hello-world-api/hello-world-api.csproj hello-world-api/
RUN dotnet restore hello-world-api/hello-world-api.csproj

# Copy entire source and publish
COPY hello-world-api/ hello-world-api/
WORKDIR /src/hello-world-api
RUN dotnet publish -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS runtime
WORKDIR /app

# Listen on port 6000
ENV ASPNETCORE_URLS=http://0.0.0.0:6000

COPY --from=build /app/out .

EXPOSE 6000
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
