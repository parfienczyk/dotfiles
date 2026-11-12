---
name: fe-sprawdz
description: Końcowa weryfikacja zmian po skończonej pracy — typecheck, lint, testy, formatowanie, zgodność z zadaniem, pozostałości (console.log, TODO, martwy kod) oraz code review diffu, z poprawą znalezionych problemów. Użyj, gdy użytkownik mówi "sprawdź raz jeszcze", "sprawdź to", "zweryfikuj", "double check" albo wpisze /fe-sprawdz. Do samego przeglądu bez poprawiania kodu użyj code-review.
argument-hint: "[opcjonalny zakres: plik, katalog lub temat]"
---

# Sprawdź raz jeszcze

Cel: złapać wszystko, co wyłapałby ponowny przegląd, zanim użytkownik uzna pracę za skończoną. Sprawdzasz własną pracę krytycznie — zakładaj, że coś jest nie tak, dopóki tego nie zweryfikujesz.

Zakres podany przez użytkownika (może być pusty): $ARGUMENTS

## 1. Ustal zakres

- Jeśli podano zakres w argumencie — sprawdzasz tylko jego.
- Jeśli w tej rozmowie wprowadzałeś zmiany — zakresem są te zmiany i zadanie, które je motywowało.
- W przeciwnym razie: zmiany na branchu względem bazy plus niezacommitowane:
  ```bash
  DEFAULT=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main)
  BASE=$(git merge-base HEAD "$DEFAULT")
  git diff --stat "$BASE"; git status --short
  ```
- Przeczytaj cały diff, nie tylko listę plików, oraz nowe pliki ze statusem `??` z `git status` (nie ma ich w `git diff`). Dla zmienionych funkcji, typów i propsów sprawdź też miejsca użycia poza diffem.

## 2. Uruchom automatyczne sprawdzenia

Znajdź komendy projektu (scripts w package.json, CLAUDE.md, Makefile, pyproject, workflowy w .github/workflows) i uruchom je, w miarę możliwości zawężone do zmian:

- typecheck (np. `yarn tsc`)
- lint (np. `yarn lint`)
- testy zmienionych pakietów lub plików (np. `yarn test <ścieżki> --watchAll=false`); jeśli zmieniona logika nie ma testów, odnotuj to
- formatowanie tylko zmienionych plików (np. `yarn prettier --check <pliki>`)

Nie uruchamiaj wolnych, pełnych zestawów (e2e, build całego repo), chyba że zmiany ich dotyczą. Błędy, które istniały przed zmianami, odnotuj osobno i nie naprawiaj ich bez pytania.

Jeśli zmiany dotyczą Reacta i dostępny jest skill `fe-react-doctor`, uruchom go.

## 3. Przegląd względem zadania

- Czy zrobiono wszystko, o co prosił użytkownik? Każdy punkt prośby powinien mieć odpowiednik w diffie.
- Czy nie zrobiono niczego ponad to: niezamówione refaktory, zmiany w niezwiązanych plikach, zbędne zmiany w lockfile?
- Pozostałości: `console.log` i inny debug, zakomentowany kod, TODO dodane w tej pracy, nieużywane importy i zmienne, pliki tymczasowe.
- Spójność z otoczeniem: nazewnictwo, wzorce, obsługa błędów, gęstość komentarzy jak w sąsiednim kodzie.

Szukanie bugów (przypadki brzegowe, async, null) zostaw krokowi 4.

## 4. Code review

Wywołaj skill `code-review` (przez Skill tool) na zmianach z kroku 1, żeby poszukać błędów poprawności. Jeśli zmiany są zacommitowane, podaj mu nazwę brancha jako cel. Nie powtarzaj w raporcie tego, co już wyszło w krokach 2–3.

## 5. Popraw i zweryfikuj ponownie

- Napraw od razu: błędy tsc, lintu, testów i formatowania wynikające z tych zmian, oczywiste bugi wprowadzone tymi zmianami, pozostałości.
- Nie naprawiaj bez pytania: rzeczy poza zakresem, błędy istniejące wcześniej, decyzje projektowe i zmiany zachowania — wypisz je.
- Po poprawkach uruchom ponownie te sprawdzenia, których poprawki dotyczyły.

## 6. Raport

Krótko, w języku użytkownika:

- wynik każdego sprawdzenia (komenda → OK / błąd)
- co poprawiono (`plik:linia`, jedno zdanie na punkt)
- co zostaje do decyzji użytkownika
- czego nie dało się sprawdzić (np. brak testów, wymaga ręcznego przeklikania UI); nie twierdź, że coś zweryfikowano, jeśli tego nie uruchomiono

Nie przepisuj całego diffu.
