#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["3de0_Identity/3de0_Identity.csproj", "3de0_Identity/"]
RUN dotnet restore "3de0_Identity/3de0_Identity.csproj"
COPY . .
WORKDIR "/src/3de0_Identity"
RUN dotnet build "3de0_Identity.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "3de0_Identity.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "3de0_Identity.dll"]
