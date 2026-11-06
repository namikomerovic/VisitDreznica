FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY VisitDreznica.Model/VisitDreznica.Model.csproj VisitDreznica.Model/
COPY VisitDreznica.Services/VisitDreznica.Services.csproj VisitDreznica.Services/
COPY VisitDreznica.API/VisitDreznica.API.csproj VisitDreznica.API/
RUN dotnet restore VisitDreznica.API/VisitDreznica.API.csproj

COPY VisitDreznica.Model/ VisitDreznica.Model/
COPY VisitDreznica.Services/ VisitDreznica.Services/
COPY VisitDreznica.API/ VisitDreznica.API/
RUN dotnet publish VisitDreznica.API/VisitDreznica.API.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime

RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080

USER $APP_UID
ENTRYPOINT ["dotnet", "VisitDreznica.API.dll"]