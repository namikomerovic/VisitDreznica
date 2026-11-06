FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY VisitDreznica.Model/VisitDreznica.Model.csproj VisitDreznica.Model/
COPY VisitDreznica.Worker/VisitDreznica.Worker.csproj VisitDreznica.Worker/
RUN dotnet restore VisitDreznica.Worker/VisitDreznica.Worker.csproj

COPY VisitDreznica.Model/ VisitDreznica.Model/
COPY VisitDreznica.Worker/ VisitDreznica.Worker/
RUN dotnet publish VisitDreznica.Worker/VisitDreznica.Worker.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/runtime:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

USER $APP_UID
ENTRYPOINT ["dotnet", "VisitDreznica.Worker.dll"]