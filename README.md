Customer Lifecycle & Cohort Analysis – KajoDataSpace Challenge

Project Overview

Analiza retencji i wartości życiowej klienta (LTV) oparta na danych transakcyjnych. Celem projektu było zidentyfikowanie kluczowych segmentów napędzających wzrost oraz zrozumienie, jak promocje i modele subskrypcyjne wpływają na lojalność użytkowników.

🛠 Tech Stack

    SQL (PostgreSQL): ETL, czyszczenie danych, logika kohortowa i segmentacja behawioralna.

    Power BI: Zaawansowana wizualizacja, analiza Kohort (Matrix) oraz Dashboarding strategiczny.

Phase 1: Data Engineering (SQL)

W tej fazie przekształciłem surowe, nieustrukturyzowane dane w relacyjną bazę gotową do analizy BI.
Key SQL Achievements:

    ETL & Data Cleaning: Naprawa formatów dat oraz konwersja separatorów dziesiętnych (z 19,99 na 19.99 numeric).

    Cohort Logic: Obliczenie month_number dla każdej transakcji względem daty pozyskania klienta.

    Behavioral Segmentation: Automatyczne przypisanie statusu New vs Returning na poziomie rekordu.

    Price Clustering: Autorska segmentacja cenowa pozwalająca odróżnić "Łowców promocji" od klientów "Elite Annual".

📊 Phase 2: Business Insights (The "So What?" Factor)

<img width="2877" height="1618" alt="image" src="https://github.com/user-attachments/assets/405b131c-0e9a-4b5c-b1ba-cf0e0983f1a2" />

Kluczowe Wnioski:

    Fundament 50/50: Przychody rozkładają się niemal idealnie pomiędzy akwizycję (48%) a retencję (51%), co świadczy o bardzo zdrowym modelu biznesowym.

    Fenomen Trial Starter: Użytkownicy wchodzący przez promocję wykazują najwyższą lojalność długoterminową – promocja u Kajo to "maszyna do budowania bazy powracających".

    Pociąg Biznesu: Segment Classic Monthly to kręgosłup finansowy firmy, wykazujący stabilną retencję mimo naturalnego churnu w pierwszym miesiącu.

    Elite Annual LTV: Klienci wysokobudżetowi generują najwyższą wartość natychmiastową (1400+ na wejściu), co pozwala na szybki zwrot kosztów marketingu (CAC).

📂 Repository Structure

    /SQL: Skrypty czyszczące i tworzące widoki analityczne.

    /PowerBI: Plik .pbix z interaktywnym raportem.

    /Screenshots: Wizualizacje i PDF z dashboardem.
