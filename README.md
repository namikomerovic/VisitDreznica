<div align="center">

<img src="docs/logo.png" alt="Visit Drežnica" width="110" />

# Visit Drežnica

**Malo mjesto. Veliki doživljaji.**

Sistem za turističku ponudu Drežnice kod Mostara: smještaj, najam opreme, organizovane aktivnosti i mjesta koja vrijedi posjetiti.<br/>
Gosti rezervišu i plaćaju kroz mobilnu aplikaciju, a administrator sve vodi iz desktop aplikacije.

![.NET 10](https://img.shields.io/badge/.NET-10-512BD4?logo=dotnet&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-desktop%20%2B%20mobile-02569B?logo=flutter&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-CC2927?logo=microsoftsqlserver&logoColor=white)
![RabbitMQ](https://img.shields.io/badge/RabbitMQ-4.2-FF6600?logo=rabbitmq&logoColor=white)
![Stripe](https://img.shields.io/badge/Stripe-pla%C4%87anje-635BFF?logo=stripe&logoColor=white)
![ML.NET](https://img.shields.io/badge/ML.NET-preporuke-1F3D2E)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)

<br/>

<img src="docs/screenshots/hero.jpg" alt="Desktop i mobilna aplikacija" width="100%" />

</div>

---

## Sadržaj

- [O projektu](#o-projektu)
- [Mobilna aplikacija](#mobilna-aplikacija)
- [Desktop aplikacija](#desktop-aplikacija)
- [Arhitektura](#arhitektura)
- [Pokretanje](#pokretanje)
- [Pristupni podaci](#pristupni-podaci)
- [Plaćanje (Stripe, test način)](#plaćanje-stripe-test-način)
- [Sistem preporuke](#sistem-preporuke)
- [Struktura repozitorija](#struktura-repozitorija)
- [Napomene](#napomene)

---

## O projektu

| 🧭 Gost (mobilna aplikacija) | 🛠️ Administrator (desktop aplikacija) |
|---|---|
| Pregled i pretraga soba, opreme, aktivnosti i mjesta | Dashboard s prihodom, rezervacijama i ocjenama |
| Detalji sa galerijom slika, recenzijama i mapom | Potvrda, odbijanje, otkazivanje i završavanje rezervacija |
| Rezervacija smještaja, najma opreme i termina aktivnosti | Upravljanje sobama, opremom, aktivnostima i terminima, mjestima, novostima |
| Online plaćanje karticom (Stripe) i povrat novca pri otkazivanju | Upravljanje korisnicima i šifarnicima |
| Favoriti, recenzije, obavijesti i novosti | Moderacija recenzija |
| Personalizovane preporuke (ML) uz objašnjenje | PDF izvještaji (finansije, zauzetost, aktivnosti) |
| Mapa mjesta s uputama do lokacije | Pregled kvaliteta modela preporuka i ručno treniranje |
| Registracija, uređivanje profila, promjena i reset lozinke | Obavijesti o novim plaćenim rezervacijama |

Obje aplikacije imaju **svijetlu i tamnu temu**, rade na **bosanskom i engleskom jeziku** i prilagođavaju se veličini ekrana (telefon, tablet, uži i širi prozor).

---

## Mobilna aplikacija

<table>
  <tr>
    <td align="center" width="25%"><img src="docs/screenshots/m02-pocetna.jpg" alt="Početna" /><br/><sub><b>Početna</b></sub></td>
    <td align="center" width="25%"><img src="docs/screenshots/m03-pocetna-preporuke.jpg" alt="Preporuke i novosti" /><br/><sub><b>Preporuke i novosti</b></sub></td>
    <td align="center" width="25%"><img src="docs/screenshots/m04-istrazi.jpg" alt="Istraži" /><br/><sub><b>Istraži</b></sub></td>
    <td align="center" width="25%"><img src="docs/screenshots/m05-detalji-sobe.jpg" alt="Detalji sobe" /><br/><sub><b>Detalji sobe</b></sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/m06-rezervacija-sobe.jpg" alt="Rezervacija sobe" /><br/><sub><b>Rezervacija i obračun</b></sub></td>
    <td align="center"><img src="docs/screenshots/m07-placanje.jpg" alt="Plaćanje karticom" /><br/><sub><b>Plaćanje (Stripe)</b></sub></td>
    <td align="center"><img src="docs/screenshots/m08-placanje-uspjelo.jpg" alt="Plaćanje uspjelo" /><br/><sub><b>Potvrda plaćanja</b></sub></td>
    <td align="center"><img src="docs/screenshots/m10-detalji-rezervacije.jpg" alt="Detalji rezervacije" /><br/><sub><b>Detalji rezervacije</b></sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/m13-detalji-aktivnosti.jpg" alt="Aktivnost" /><br/><sub><b>Aktivnost i termini</b></sub></td>
    <td align="center"><img src="docs/screenshots/m11-mapa.jpg" alt="Mapa mjesta" /><br/><sub><b>Mapa mjesta</b></sub></td>
    <td align="center"><img src="docs/screenshots/m09-moje-rezervacije.jpg" alt="Moje rezervacije" /><br/><sub><b>Moje rezervacije</b></sub></td>
    <td align="center"><img src="docs/screenshots/m14-favoriti.jpg" alt="Favoriti" /><br/><sub><b>Favoriti</b></sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/m01-prijava.jpg" alt="Prijava" /><br/><sub><b>Prijava</b></sub></td>
    <td align="center"><img src="docs/screenshots/m12-profil.jpg" alt="Profil" /><br/><sub><b>Profil, tema i jezik</b></sub></td>
    <td align="center"><img src="docs/screenshots/m16-pocetna-tamna.jpg" alt="Tamna tema" /><br/><sub><b>Tamna tema</b></sub></td>
    <td align="center"><img src="docs/screenshots/m17-pocetna-en.jpg" alt="Engleski jezik" /><br/><sub><b>English</b></sub></td>
  </tr>
</table>

---

## Desktop aplikacija

<table>
  <tr>
    <td align="center" width="50%"><img src="docs/screenshots/d02-dashboard.jpg" alt="Dashboard" /><br/><sub><b>Dashboard</b>: prihod po mjesecima, rezervacije po statusu, ocjene</sub></td>
    <td align="center" width="50%"><img src="docs/screenshots/d03-rezervacije.jpg" alt="Rezervacije" /><br/><sub><b>Rezervacije</b>: pretraga i filteri po vrsti, statusu i periodu</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/d04-detalji-rezervacije.jpg" alt="Detalji rezervacije" /><br/><sub><b>Detalji rezervacije</b>: potvrda ili odbijanje uz historiju statusa</sub></td>
    <td align="center"><img src="docs/screenshots/d05-sobe.jpg" alt="Sobe" /><br/><sub><b>Sobe</b>: lista sa slikama, tipom, kapacitetom i cijenom</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/d06-forma-sobe.jpg" alt="Forma sobe" /><br/><sub><b>Forma sobe</b>: sadržaji i galerija s naslovnom slikom</sub></td>
    <td align="center"><img src="docs/screenshots/d07-forma-mjesta.jpg" alt="Forma mjesta" /><br/><sub><b>Forma mjesta</b>: lokacija se bira klikom na mapu</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/d08-aktivnost-termini.jpg" alt="Termini aktivnosti" /><br/><sub><b>Aktivnost</b>: termini s vodičem i popunjenošću</sub></td>
    <td align="center"><img src="docs/screenshots/d09-recenzije.jpg" alt="Recenzije" /><br/><sub><b>Recenzije</b>: filter po vrsti i rasponu ocjene</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/d10-izvjestaji.jpg" alt="Izvještaji" /><br/><sub><b>Izvještaji</b>: tri PDF izvještaja za odabrani period</sub></td>
    <td align="center"><img src="docs/screenshots/d11-preporuke-ml.jpg" alt="Preporuke ML" /><br/><sub><b>Preporuke (ML)</b>: kvalitet modela u odnosu na osnovne pristupe</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/screenshots/d12-dashboard-tamna.jpg" alt="Tamna tema" /><br/><sub><b>Tamna tema</b></sub></td>
    <td align="center"><img src="docs/screenshots/d13-sifarnici.jpg" alt="Šifarnici" /><br/><sub><b>Šifarnici</b>: tipovi, sadržaji, kategorije, vodiči, države, gradovi</sub></td>
  </tr>
</table>

<details>
<summary><b>Prijava i prikaz u uskom prozoru</b></summary>
<br/>
<table>
  <tr>
    <td align="center" width="50%"><img src="docs/screenshots/d01-prijava.jpg" alt="Prijava" /><br/><sub><b>Prijava</b> s izborom jezika</sub></td>
    <td align="center" width="50%"><img src="docs/screenshots/d14-uski-prozor.jpg" alt="Uski prozor" /><br/><sub><b>Uski prozor</b>: forma prelazi u jednu kolonu</sub></td>
  </tr>
</table>
</details>

---

## Arhitektura

```mermaid
flowchart LR
    M["📱 Mobilna aplikacija<br/>(Flutter, gost)"] -->|REST + JWT| API
    D["🖥️ Desktop aplikacija<br/>(Flutter, admin)"] -->|REST + JWT| API
    API["VisitDreznica.API<br/>ASP.NET Core"] --> DB[("SQL Server<br/>baza 230007")]
    API -->|PaymentIntent, povrat| S["Stripe"]
    API -->|poruka za e-mail| Q[["RabbitMQ"]]
    Q --> W["VisitDreznica.Worker<br/>(MailKit)"]
    W -->|SMTP| E["✉️ E-mail gostu"]
    API -.->|trenira svakih 6 h| ML["ML.NET<br/>Matrix Factorization"]
```

| Projekat | Uloga |
|---|---|
| `VisitDreznica.API` | REST API, JWT autentifikacija i uloge, pozadinsko treniranje modela i istek neplaćenih rezervacija |
| `VisitDreznica.Services` | Poslovna logika, EF Core (Code First, migracije), stanja rezervacije, Stripe, preporuke, PDF izvještaji, seed |
| `VisitDreznica.Model` | Zahtjevi, odgovori, enumi, izuzeci i prijevodi poruka (bs/en) |
| `VisitDreznica.Worker` | Prima poruke iz RabbitMQ-a i šalje e-mailove gostima (npr. promjena statusa rezervacije, kod za reset lozinke) |
| `UI/visitdreznica_core` | Zajednički Flutter paket: API klijent, modeli, servisi, tema, prijevodi |
| `UI/visitdreznica_desktop` | Desktop aplikacija za administratora (Windows) |
| `UI/visitdreznica_mobile` | Mobilna aplikacija za goste (Android) |

**Tehnologije:** .NET 10, ASP.NET Core, Entity Framework Core, SQL Server 2022, RabbitMQ, MailKit, Stripe.net, ML.NET, QuestPDF, Mapster · Flutter, Provider, flutter_stripe, flutter_map (OpenStreetMap), fl_chart · Docker Compose.

---

## Pokretanje

### Preduslovi

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.44 ili noviji) s podrškom za Windows desktop i Android
- Android emulator ili telefon (za mobilnu aplikaciju)

### 1. Konfiguracija (`.env`)

Sve tajne i postavke (baza, RabbitMQ, JWT, Stripe, SMTP) čitaju se iz fajla `.env`, koji se iz sigurnosnih razloga ne nalazi u repozitoriju.
Fajl se dobija odvojeno (kao `.env-tajne.zip` zaštićen šifrom) i raspakuje u korijen repozitorija, tako da `.env` stoji pored `docker-compose.yml`.

### 2. Backend (Docker)

```powershell
docker compose up -d --build
```

Pokreću se četiri kontejnera: SQL Server, RabbitMQ, API i Worker. Pri prvom pokretanju API sam:

1. napravi bazu kroz migracije,
2. ubaci početne podatke (korisnike, ponudu sa slikama, rezervacije, recenzije…),
3. istrenira model preporuka.

| Servis | Adresa |
|---|---|
| API | http://localhost:5291 |
| Dokumentacija API-ja (Scalar) | http://localhost:5291/scalar |
| RabbitMQ panel | http://localhost:15672 |

Za potpuno novu instalaciju (briše bazu): `docker compose down -v`, pa ponovo `docker compose up -d --build`.

### 3. Desktop aplikacija

```powershell
cd UI/visitdreznica_core
flutter pub get
flutter gen-l10n

cd ../visitdreznica_desktop
flutter pub get
flutter run -d windows
```

Adresa API-ja se zadaje pri pokretanju (`--dart-define=API_BASE_URL=...`), a podrazumijevana je `http://localhost:5291`.

### 4. Mobilna aplikacija

**Android emulator** (emulator API vidi na adresi `10.0.2.2`, što je i podrazumijevana vrijednost):

```powershell
cd UI/visitdreznica_mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5291
```

**Telefon preko USB kabla:**

```powershell
adb reverse tcp:5291 tcp:5291
flutter run --dart-define=API_BASE_URL=http://localhost:5291
```

### Gotovi buildovi

U [Releases](../../releases) se nalazi `fit-build-<datum>.zip` sa:

- **Android APK** (`app-release.apk`), napravljen za emulator (`API_BASE_URL=http://10.0.2.2:5291`)
- **Windows aplikacija** (`Release` folder), pokreće se sa `visitdreznica_desktop.exe` (`API_BASE_URL=http://localhost:5291`)

Backend se i tada pokreće kroz Docker, kao u koraku 2.

---

## Pristupni podaci

| Aplikacija | Korisničko ime | Lozinka | Napomena |
|---|---|---|---|
| Desktop (administrator) | `desktop` | `test` | |
| Mobilna (gost) | `mobile` | `test` | nov gost bez historije: prikazuje popularne stavke (hladan start) |
| Mobilna (gost) | `lejla.kovac` | `test` | gost s historijom: personalizovane preporuke, rezervacije, favoriti |

Svi ostali gosti iz početnih podataka (npr. `sara.maric`, `tarik.begic`, `emina.mehic`) također imaju lozinku `test`.

---

## Plaćanje (Stripe, test način)

Plaćanje radi u **Stripe test načinu**, bez stvarnog novca. Za probu se koristi testna kartica:

| Broj kartice | Datum isteka | CVC |
|---|---|---|
| `4242 4242 4242 4242` | bilo koji budući datum (npr. `12/34`) | bilo koja 3 broja |

- Server **sam provjerava** status uplate kod Stripea; aplikacija ne može „lažno" potvrditi plaćanje.
- Pri otkazivanju plaćene rezervacije novac se **automatski vraća** na karticu.
- Neplaćena rezervacija se otkazuje nakon 30 minuta.

---

## Sistem preporuke

Gost na početnom ekranu dobija personalizovane preporuke iz cijele ponude, uz objašnjenje zašto je nešto preporučeno.

- **Metoda:** kolaborativno filtriranje, *one-class Matrix Factorization* (ML.NET).
- **Signali:** recenzije, favoriti, rezervacije i pregledi detalja.
- **Kvalitet (HitRate@3):** **0.370**, naspram 0.130 za preporuku po popularnosti i 0.170 za slučajan izbor.
- **Hladan start:** novi gosti dobijaju popularne stavke (Bayesov prosjek).

Detaljno: [`recommender-dokumentacija.md`](recommender-dokumentacija.md).

---

## Struktura repozitorija

```
VisitDreznica/
├── VisitDreznica.API/          # REST API (ASP.NET Core)
├── VisitDreznica.Services/     # poslovna logika, EF Core, seed (Database/Seed/Images)
├── VisitDreznica.Model/        # DTO-i, enumi, izuzeci, prijevodi poruka
├── VisitDreznica.Worker/       # slanje e-mailova (RabbitMQ → SMTP)
├── UI/
│   ├── visitdreznica_core/     # zajednički Flutter paket (API, modeli, tema, prijevodi)
│   ├── visitdreznica_desktop/  # admin aplikacija (Windows)
│   └── visitdreznica_mobile/   # aplikacija za goste (Android)
├── docs/                       # slike za README
├── docker-compose.yml
└── recommender-dokumentacija.md
```

---

## Napomene

- **Fotografije:** fotografije u aplikaciji i početnim podacima preuzete su s javno dostupnih izvora i koriste se isključivo u nekomercijalne, edukativne svrhe. Sva prava pripadaju njihovim autorima.
- **Mape:** © [OpenStreetMap](https://www.openstreetmap.org/copyright) contributors.
- **Fontovi:** [DM Sans](https://fonts.google.com/specimen/DM+Sans) i [Fraunces](https://fonts.google.com/specimen/Fraunces), oba pod licencom SIL Open Font License 1.1 (licence se nalaze uz fontove u `UI/visitdreznica_core/assets/fonts`).
- **Jezik:** aplikacije, poruke grešaka i objašnjenja preporuka prate izabrani jezik (bosanski/engleski). Sadržaj koji unosi administrator (nazivi, opisi, novosti), e-mailovi, obavijesti i PDF izvještaji su na bosanskom.

---

<div align="center">

Napravio **Namik Omerović** · 2026.

</div>
