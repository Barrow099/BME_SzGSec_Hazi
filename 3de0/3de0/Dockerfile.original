#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["3de0/3de0.csproj", "3de0/"]
RUN dotnet restore "3de0/3de0.csproj"
COPY . .
WORKDIR "/src/3de0"
RUN dotnet build "3de0.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "3de0.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "3de0.dll"]