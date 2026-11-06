# Sistem preporuke – Visit Drežnica

Dokumentacija sistema preporuke implementiranog prema zahtjevu iz komentara na prijavu teme:
*„Dodati sistem preporuke baziran na nekom od poznatih ML metoda i algoritama."*

---

## 1. Cilj

Gostu se na početnom ekranu mobilne aplikacije prikazuju personalizovane preporuke iz cjelokupne ponude:
sobe, oprema (kajaci), organizovane aktivnosti i mjesta (plaže, priroda, znamenitosti).
Uz svaku preporuku prikazuje se i **objašnjenje** zašto je preporučena.

Sistem ne preporučuje stavke koje je gost već ocijenio, stavio u favorite ili za koje je
jasno pokazao da ih voli, jer je svrha preporuke da gost otkrije nešto novo.

---

## 2. Korištena metoda

**Kolaborativno filtriranje pomoću faktorizacije matrice (Matrix Factorization)**,
u varijanti za implicitne povratne informacije (**one-class Matrix Factorization**).

- Biblioteka: **ML.NET** (`Microsoft.ML`, `Microsoft.ML.Recommender`), trener `MatrixFactorizationTrainer`
  (zasnovan na biblioteci LIBMF).
- Funkcija gubitka: `SquareLossOneClass`.

### Ideja algoritma

Interakcije gostiju sa stavkama čine matricu *gost × stavka* u kojoj je većina polja prazna
(niko nije probao sve). Algoritam svakom gostu `u` i svakoj stavci `i` dodjeljuje vektor od
`k` brojeva (latentni faktori, „skriveni ukusi"):

```
p_u ∈ ℝᵏ   – ukus gosta
q_i ∈ ℝᵏ   – profil stavke
```

Relevantnost stavke za gosta procjenjuje se skalarnim proizvodom:

```
r̂_ui = p_u · q_i
```

U one-class varijanti model se uči da:
- za stavke koje je gost **izabrao** proizvod bude blizu jačine izbora (oznaka 0.6–1.0),
- za stavke koje gost **nije izabrao** proizvod bude blizu nule (`C = 0.00001`),
  ali sa malom težinom `α`, jer neizabrano ne znači nužno „ne sviđa mi se", nego često samo „nisam probao".

Minimizira se:

```
Σ_(u,i) izabrano (r_ui − p_u·q_i)²  +  α · Σ_(u,i) neizabrano (C − p_u·q_i)²  +  λ (‖p_u‖² + ‖q_i‖²)
```

gdje je `λ` regularizacija koja sprječava pretjerano prilagođavanje (overfitting) malom skupu podataka.

---

## 3. Podaci (signali)

Model uči iz četiri izvora koje aplikacija bilježi. Svaki signal se pretvara u
**implicitnu ocjenu 1–5**; ako gost ima više signala za istu stavku, uzima se najjači,
a recenzija uvijek ima prednost jer je izričito mišljenje gosta.

| Signal | Implicitna ocjena |
|---|---|
| Recenzija (1–5 ★) | tačno ta ocjena (**prepisuje sve ostalo**) |
| Favorit ♥ | 4.5 |
| Završena rezervacija | 4.0 |
| Potvrđena rezervacija | 3.5 |
| Pregled detalja: 1× / 2× / 3+× | 2.5 / 3.0 / 3.5 |

**Izbor (pozitivna interakcija)** je svaka interakcija s ocjenom **≥ 3.0**.
Jedan jedini pregled (2.5) nije izbor jer je gost možda samo listao, a niska recenzija (1–2)
nije izbor jer je gost izričito rekao da mu se stavka ne sviđa.

Recenziju za sobu, opremu ili aktivnost može ostaviti samo gost koji ima **završenu rezervaciju**
te stavke (sprječavanje lažnih recenzija); mjesta (plaže, znamenitosti) može ocijeniti svaki gost.

Kod: `VisitDreznica.Services/Recommendations/InteractionDataLoader.cs`, `InteractionWeights.cs`.

---

## 4. Razvoj modela – tri iteracije

Model nije napravljen „iz prve". Svaka verzija je izmjerena i upoređena s jednostavnim
osnovnim pristupom (baseline), a odluke su donesene na osnovu mjerenja.

### Iteracija 1 – klasični Matrix Factorization (predviđanje ocjene)

- Model predviđa ocjenu 1–5; mjera je **RMSE** (korijen srednje kvadratne greške).
- Jedna podjela podataka 80 % / 20 %.

| | RMSE |
|---|---|
| Baseline: globalni prosjek | 1.127 |
| Matrix Factorization | **1.429** ❌ |

Model je bio **lošiji od pogađanja prosjeka**. Mjerenje na samo 20 testnih ocjena bilo je i nepouzdano.

### Iteracija 2 – Biased MF + 5-fold cross-validation

Uvedena je standardna dopuna (Koren, Netflix Prize): ocjena se rastavlja na
`μ + b_gost + b_stavka + p_u·q_i`, gdje MF uči samo ostatak koji prosjeci ne objašnjavaju.
Parametri su birani 5-strukom unakrsnom validacijom (svih 145 interakcija jednom u testu).

| | RMSE |
|---|---|
| Baseline: globalni prosjek | 1.120 |
| Prosjek + pristranosti gosta i stavke | 1.241 |
| Biased MF | **1.172** ❌ |

Ni ovo nije bilo bolje od prosjeka, a čak su i pristranosti bile lošije od prosjeka.
To je pokazalo da problem **nije u parametrima, nego u postavci zadatka**.

### Analiza: zašto predviđanje ocjene ne radi

Gost uglavnom **koristi ono što voli** i to onda ocijeni visoko; ono što ne voli rijetko i koristi,
pa za to skoro nikad nema ocjene. Zbog toga su gotovo sve poznate ocjene visoke i prosjek ih
već dobro pogađa. Ova pojava se u literaturi naziva **pristranost odabira (selection bias)**, a podaci
ovakve vrste **implicitne povratne informacije (implicit feedback)**.

Stvarno znanje u podacima nije *„koliko će gost ocijeniti"*, nego *„šta će gost uopšte izabrati"*.
Za sistem preporuke upravo je to bitno: korisnik vidi **listu**, pa je važan **redoslijed**, a ne tačna ocjena.

### Iteracija 3 – one-class Matrix Factorization + metrika rangiranja ✅

- Funkcija gubitka promijenjena u `SquareLossOneClass` (model uči razliku *bira / ne bira*).
- Mjera promijenjena u **HitRate@3**: za gosta se sakrije jedna stavka koju je stvarno izabrao,
  model se trenira bez nje i provjerava se da li je ta stavka među **top 3 preporuke** iz skupa
  stavki koje gost još nije izabrao.

Ova verzija je u upotrebi. Rezultati su u sljedećem poglavlju.

---

## 5. Evaluacija

### Postupak

1. Svi izbori svakog gosta (s bar 2 izbora) poredaju se slučajnim, ali fiksnim redoslijedom (`seed = 42`).
2. Podaci se dijele u **5 foldova** tako da je u svakom foldu sakriven po jedan dio izbora svakog gosta;
   na kraju je **svaki izbor tačno jednom sakriven**, a gost uvijek ima nešto u treningu.
3. Za svaki fold model se trenira na ostatku, a za svaki sakriveni izbor provjerava se pogodak u top 3.
4. Isti postupak primjenjuje se na dva poredbena pristupa:
   - **Popularnost** – svima se preporučuju 3 najčešće birane stavke,
   - **Slučajno** – očekivani pogodak pri nasumičnom izboru (`3 / broj kandidata`).

### Izbor parametara

Isprobano je 6 kombinacija; izabrana je ona s najvećim HitRate@3:

| Rank (k) | λ | α |
|---|---|---|
| 4 | 0.025 | 0.01 |
| 4 | 0.1 | 0.01 |
| 8 | 0.025 | 0.01 |
| **8** | **0.1** | **0.01** ← izabrano |
| 8 | 0.1 | 0.1 |
| 16 | 0.1 | 0.01 |

Ostali parametri: 50 iteracija, `C = 0.00001`, jedna nit (`NumberOfThreads = 1`) radi ponovljivosti.

### Rezultati

Skup podataka: 145 interakcija, od toga 96 izbora, 21 gost, 16 stavki; evaluirano 95 sakrivenih izbora.

| Pristup | HitRate@3 |
|---|---|
| Slučajno | 0.252 |
| Popularnost | 0.389 |
| **One-class Matrix Factorization** | **0.579** |

Model pogađa stvarno izabranu stavku u **58 %** slučajeva, što je
**≈ 49 % bolje od preporuke po popularnosti** i **≈ 2.3× bolje od slučajnog izbora**.
Time je pokazano da model stvarno **personalizuje**, a ne samo preporučuje ono što je općenito popularno.

Trenutne vrijednosti uvijek su dostupne administratoru preko `GET /Recommendations/model`
i ispisuju se u logu pri svakom treniranju.

---

## 6. Objašnjenje preporuka

Uz svaku personalizovanu preporuku računa se objašnjenje:

1. Uzmu se stavke koje je gost volio (implicitna ocjena ≥ 4).
2. Za svaku se izračuna **kosinusna sličnost** s preporučenom stavkom, gdje je stavka predstavljena
   vektorom ocjena svih gostiju (koji su gosti voljeli tu stavku).
3. Ako je najveća sličnost ≥ 0.1, objašnjenje glasi:
   *„Gostima kojima se svidjelo „Vožnja splavom kanjonom Neretve" često se sviđa i ovo."*
   U suprotnom: *„Odgovara vašim dosadašnjim interesima."*

Kod: `RecommendationService.ExplainPersonal`.

---

## 7. Hladan start (cold start)

| Situacija | Ponašanje |
|---|---|
| U sistemu ima manje od 20 izbora, 3 gosta ili 3 stavke | model se ne trenira |
| Gost nema nijedan izbor (nov korisnik) | model ga ne poznaje |

U oba slučaja vraćaju se **popularne stavke**, rangirane **Bayesovim prosjekom**:

```
score_i = (Σ ocjena_i + m · μ) / (n_i + m),   m = 3
```

Tako stavka s jednom ocjenom 5 ne može nadvladati stavku s dvadeset ocjena 4.8.
Objašnjenje glasi *„Popularno među gostima."*, a polje `isPersonalized` je `false`.

---

## 8. Treniranje u radu aplikacije

- Model se trenira **pri pokretanju API-ja** i zatim **svakih 6 sati** (`RecommenderTrainingWorker`, `BackgroundService`).
- Administrator može pokrenuti treniranje ručno: `POST /Recommendations/train`.
- Treniranje se izvršava izvan niti koja obrađuje zahtjeve (`Task.Run`), a istovremena treniranja
  sprječava `SemaphoreSlim`.
- Novi model se istrenira sa strane i **jednom dodjelom** zamijeni stari (`RecommenderModelStore`),
  pa zahtjev nikad ne vidi napola istreniran model.
- Ocjenjivanje kandidata koristi `ITransformer.Transform` nad cijelom listom kandidata, što je
  sigurno za istovremene zahtjeve (za razliku od ML.NET `PredictionEngine`).

---

## 9. API

| Metoda | Ruta | Uloga | Opis |
|---|---|---|---|
| GET | `/Recommendations?itemType=&take=` | Gost | Preporuke za prijavljenog gosta (do 20), opcionalno samo jedna vrsta stavke |
| GET | `/Recommendations/model` | Admin | Stanje modela i metrike evaluacije |
| POST | `/Recommendations/train` | Admin | Ručno treniranje |

Primjer odgovora (`GET /Recommendations`):

```json
[
  {
    "itemType": 3,
    "itemId": 2,
    "itemName": "Pješačka tura kanjonom Drežanke",
    "score": 0.912,
    "reason": "Gostima kojima se svidjelo „Vožnja splavom kanjonom Neretve" često se sviđa i ovo.",
    "isPersonalized": true
  }
]
```

`itemType`: 1 = soba, 2 = oprema, 3 = aktivnost, 4 = mjesto.
`score` je relevantnost (veće = bolje uklapanje), a ne ocjena.

---

## 10. Podaci za demonstraciju

Seed (`DbSeeder.Interactions.cs`) generiše 20 gostiju u četiri persone s različitim ukusima:

| Persona | Primjer gosta | Voli |
|---|---|---|
| Avanturisti | `lejla.kovac` | splavarenje, kajak, kanjon, vrelo |
| Odmor uz rijeku | `sara.maric` | sobe s pogledom, plaže, kajak dvosjed |
| Priroda i historija | `tarik.begic` | pješačke ture, historijska tura, znamenitosti |
| Porodice | `emina.mehic` | porodične sobe, plaže, kajak dvosjed |

Svaki gost ima završene rezervacije s plaćanjem i historijom statusa, recenzije (samo za korišteno),
favorite i preglede, s namjernim „šumom" u ocjenama. Generator koristi fiksni seed (`2026`),
pa svaka instalacija dobije iste podatke i iste rezultate evaluacije.

Korisnik `mobile` namjerno nema historiju, kako bi se mogao demonstrirati **hladan start**.
Lozinka svih korisnika je `test`.

---

## 11. Ograničenja i mogući nastavak

- Skup podataka je mali i djelimično sintetički; metrike treba ponovo izmjeriti nad stvarnim korištenjem.
- Model ne koristi sadržaj stavki (kategorija, cijena, udaljenost). Hibrid kolaborativnog i
  sadržajnog (content-based) filtriranja bi pomogao novim stavkama koje još niko nije izabrao.
- Model ne uzima u obzir vrijeme (sezonu): ljeti su plaže zanimljivije nego zimi.
- Evaluacija je offline; u produkciji bi se mjerilo i koliko često gosti zaista otvore ili
  rezervišu preporučeno (online metrika, A/B test).

---

## 12. Lokacije u kodu

| Fajl | Uloga |
|---|---|
| `Services/Recommendations/InteractionDataLoader.cs` | učitavanje signala iz baze i pretvaranje u implicitne ocjene |
| `Services/Recommendations/InteractionWeights.cs` | težine signala i pragovi |
| `Services/Recommendations/ImplicitMfModel.cs` | treniranje i predikcija (ML.NET one-class MF) |
| `Services/Recommendations/RecommenderTrainer.cs` | izbor parametara, evaluacija, treniranje finalnog modela |
| `Services/Recommendations/RecommenderModelStore.cs` | čuvanje aktivnog modela (singleton) |
| `Services/Recommendations/RecommendationService.cs` | preporuke, objašnjenja, hladan start |
| `API/BackgroundServices/RecommenderTrainingWorker.cs` | periodično treniranje |
| `API/Controllers/RecommendationsController.cs` | API |
| `Services/Database/Seed/DbSeeder.Interactions.cs` | demonstracijski podaci |
