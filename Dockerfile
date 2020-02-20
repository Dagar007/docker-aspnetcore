FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["DockerNetCore.csproj", "./"]
RUN dotnet restore "./DockerNetCore.csproj"
COPY . .
RUN dotnet build "DockerNetCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerNetCore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerNetCore.dll"]
