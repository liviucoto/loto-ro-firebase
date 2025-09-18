# 📐 Standarde UI LotoRO

## Paletă de culori
- Verde pastel (principal): #6EE7B7, #34D399, #059669
- Albastru pastel (secundar): #A7C7E7, #60A5FA
- Galben pastel: #FDE68A, #FBBF24
- Mov pastel: #C4B5FD, #A78BFA
- Roșu pastel: #FCA5A5, #F87171
- Gri/white glass: #F3F4F6, #E5E7EB
- Glass: #FFFFFF (cu opacitate 0.35-0.5)
- Border glass: #FFFFFF (opacitate 0.2-0.5)

## Fonturi
- Titluri: Poppins/Montserrat/Inter, bold, 18-24px
- Text normal: Montserrat, 14-16px
- Caption: 12px, gri
- Numere extrase: font mare, bold, shadow alb

## Dimensiuni & Spacing
- Padding carduri: 16px (desktop), 8px (mobil)
- Spațiu între carduri: 18px (desktop), 8px (mobil)
- Border radius carduri: 18px
- Border radius butoane: 12-16px
- Înălțime butoane: 40px (desktop), 32px (mobil)
- Iconuri: 16-24px
- Bile: 28-36px

## Efecte vizuale
- Glassmorphism: BackdropFilter blur (sigmaX/Y: 12-14), overlay alb opacitate 0.35, border alb semi-transparent 1.5px, shadow subtil
- Gradient: doar pe butoane și bottom navigation
- Shadow: BoxShadow negru opacitate 0.10-0.13, blur 8-16px
- Highlight subtil: dungă albă semitransparentă sus pe carduri

## Responsive
- Carduri și bare centrate, maxWidth 900px pe desktop
- Spațiere și fonturi mai mici pe mobil
- Statisticile sub bile pe mobil, wrap automat
- Icon-only la filtre/sortare pe mobil

## Accesibilitate
- Contrast ridicat text/elemente interactive
- Fonturi mari, scalabile
- Toate iconițele au semantic label
- Animații subtile, non-intruzive

## Reguli de utilizare
- Toate componentele folosesc constantele din `constants.dart`
- Orice tab nou trebuie să respecte aceste standarde
- Nu se folosesc culori/dimensiuni hardcodate în widgeturi

## Exemple cod
```dart
// Folosire culoare și font standard
Text('Exemplu', style: AppFonts.bodyStyle.copyWith(color: AppColors.primaryGreen))

// Card glassmorphism
GlassCard(
  padding: EdgeInsets.all(AppSizes.paddingMedium),
  borderRadius: BorderRadius.circular(18),
  child: ...,
)
```

# Standard UI/UX - Grafic Statistic (model: Frecvență)

> ✅ **VERIFICAT**: Graficele de frecvență și sumă respectă perfect aceste standarde și sunt aliniate.

## 1. Container principal
- Componentă: `GlassCard`
- Padding: `EdgeInsets.symmetric(horizontal: 32, vertical: 28)` (desktop), `EdgeInsets.symmetric(horizontal: 10, vertical: 10)` (mobil)
- Border radius: 24

## 2. Header
- Row cu:
  - **Titlu:** (ex: "Graficul frecvenței" / "Graficul sumei")
    - Font: `AppFonts.titleStyle`
    - Font size: 19 (desktop) / 16 (mobil)
  - **Selector perioadă:** `PeriodSelectorGlass`
    - Font size: 15
    - Icon size: 18
    - Fără container suplimentar, doar underline
    - Padding: zero

## 3. Body
- **Grafic:**
  - Înălțime: 370px (desktop) / 260px (mobil)
  - Padding: vertical 10
  - Parametru: `mainRange` calculat din date (unde e cazul)
- **Legendă:**
  - Text pe o singură linie, fără badge-uri colorate
  - Exemplu frecvență: `Total extrageri: x | Medie frecvență: x | Cel mai frecvent: x | Cel mai rar: x`
  - Exemplu sumă: `Total extrageri: x | Medie sumă: x | Min: x | Max: x | Media mică: x | Media mare: x`
  - Font: `AppFonts.captionStyle`
  - Font size: 10.5 (desktop) / 8 (mobil)
  - Culoare: #00000088 (Colors.black.withOpacity(0.53))
  - textAlign: center
  - Padding: only(top: 0, bottom: 0)

## 4. Spațiere
- `SizedBox(height: 32)` (desktop) / `20` (mobil) între legendă și butoane

## 5. Footer
- Row cu `mainAxisAlignment: spaceBetween`:
  - **Buton Generator:** `TextButton.icon`
    - Text: "Generator Frecvență" / "Generator Sumă" etc.
    - Icon: `Icons.auto_mode`
    - Font: 13 (desktop) / 11 (mobil)
    - Icon size: 18 (desktop) / 15 (mobil)
    - Padding: `EdgeInsets.symmetric(horizontal: 10, vertical: 6)` (desktop) / `EdgeInsets.symmetric(horizontal: 7, vertical: 4)` (mobil)
    - Border radius: 12 (desktop) / 10 (mobil)
    - Border color: #00000022 (Colors.black.withOpacity(0.13))
    - Border width: 1
    - Background: Colors.white.withOpacity(0.13)
    - Foreground: Colors.blueGrey
  - **Buton Analiză narativă:** la fel ca generator, dar cu `Icons.info_outline` și text "Analiză narativă"
    - Deschide dialog glass cu narativă și selector perioadă

## 6. Dialog Analiză narativă
- Glass effect: blur 18, background alb cu opacitate 0.58, border alb 28%, borderRadius 24, boxShadow negru 10%, blur 24
- Header dialog: Row cu icon, titlu "Analiză narativă", selector perioadă (aceleași fonturi și spacing ca în card)
- Body: narativă + legendă, spacing 16 între titlu și narativă, 18 între narativă și buton închidere
- Buton închidere: dreapta jos, `TextButton` "Închide"

## 7. Tooltip-uri
- **Frecvență:** Tooltip simplu cu numărul și frecvența
- **Sumă:** Tooltip cu extragerea, data, sumă, media, media mică, media mare
- **Comportament:** Doar pentru linia principală (barIndex == 0) pentru a evita tooltip-uri duplicate
- **Stil:** Background alb translucid, border portocaliu, font weight 500, shadow alb

## 8. Alte reguli
- Toate fonturile, iconurile, padding-ul și spacing-ul se scalează pe mobil
- Componentele nu se suprapun, spacing constant între elemente
- Nu există badge-uri colorate, totul e pe o singură linie, stil aerisit
- Iconuri consistente, nuanțe pastel, nu se folosesc culori tari
- Toate componentele folosesc `AppFonts` și `AppColors` din `constants.dart`
- Nu există spațiu mort sub card
- Nu se folosesc dimensiuni sau culori hardcodate în widgeturi

> ✅ **STATUS**: Acest standard este obligatoriu și verificat pentru toate graficele din tabul Statistici. Graficele de frecvență și sumă sunt perfect aliniate cu aceste standarde.

## Standard UI/UX: Buton Full Screen pentru Grafice

- Toate graficele de statistici trebuie să aibă un buton de full screen subtil, poziționat în colțul dreapta-jos al containerului graficului.
- Icon: `Icons.fullscreen`, dimensiune mică (20px), opacitate 0.65, fundal alb translucid, border radius 16.
- Poziționare: `Positioned(bottom: 10, right: 10)` în containerul graficului.
- La click/tap: se deschide un dialog/modal cu graficul pe tot ecranul, fundal blurat, padding generos, border radius 28, close cu X sau click exterior/ESC.
- În modul full screen, graficul este centrat și are dimensiuni maxime (`900x600` desktop, `98vw x 85vh` mobil).
- Butonul de full screen trebuie să fie prezent la toate graficele pentru consistență vizuală și UX.

## Selectoare de perioadă
- Toate graficele statistice folosesc același selector de perioadă: `PeriodSelectorGlass`.
- Opțiuni standard: "Ultimele N", "Toate extragerile", "Custom" (cu dialog pentru introducere număr).
- Nu se folosesc selectoare numerice separate sau alte variante pentru intervale.
- Selectorul este prezent atât în header-ul cardului, cât și în dialogul de analiză narativă.
- Comportament: la schimbarea perioadei, datele și narativa se recalculează dinamic.

## Narativă analiză statistică
- Toate graficele folosesc narativă structurată, nu badge-uri, nu fraze lungi, nu wrap.
- Fiecare insight/statistică este pe rând propriu, cu iconiță și text scurt, stil similar cu graficul de frecvență și interval.
- Narativa se afișează exclusiv în dialog glass, cu selector de perioadă în header.
- Structura narativei este specifică fiecărui tip de grafic (ex: frecvență, sumă, interval, medie etc), dar stilul este unitar:
  - Rânduri cu iconiță și text clar (ex: "Top 5 cele mai mari sume: ...", "Cea mai mică sumă: ...", "Intervalul cu cele mai multe extrageri: ...")
  - Nu se folosesc badge-uri colorate, nu se folosește wrap, nu se folosesc fraze lungi sau paragrafe.
  - Se evidențiază insight-uri relevante pentru fiecare tip de grafic (vezi exemplele din cod pentru frecvență, sumă, interval).
- Dialogul narativ respectă stilul glass, cu blur, border, shadow, padding generos și buton de închidere în dreapta jos. 