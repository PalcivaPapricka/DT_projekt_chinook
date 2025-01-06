# **Databázové technológie ETL projekt chinook**

**Autor**: Viktor Kramár

Môj projekt sa zameriava na spracovanie údajov z Chinook databázy prostredníctvom ETL procesu v rámci hviezdicovej schémy.

**Zdrojový dataset:** 
Chinook databáza je vzorová relačná databáza, ktorá obsahuje údaje o hudobných albumoch, skladbách, umelcoch, zákazníkoch, objednávkach a faktúrach. 
Dáta z Chinook databázy budú transformované a optimalizované na analytické účely pomocou platformy Snowflake.

---
## **1. Úvod a popis zdrojových dát**
Cieľom semestrálneho projektu je analyzovať dáta v databáze Chinook, pričom sa zameriame na používateľov, ich preferencie a a kúpi skladieb . Táto analýza umožní identifikovať trendy v záujmoch používateľov, najpopulárnejšie položky (napríklad skladby alebo albumy) a správanie používateľov.
Dataset obsahuje tabulky:
- `playlist`: Informácie o playlistoch vytvorených užívatelmi.
- `playlisttrack`: Spojovacia tabuľka pre playlisty a skladby.
- `track`: Informácie o skladbách.
- `album`: Informácie o hudobných albumoch.
- `artist`: Informácie o interpretoch.
- `customer`: Informácie o zákazníkoch.
- `employee`: Informácie o zamestnancoch.
- `genre`: Informácie o žánroch skladieb.
- `invoice`: Informácie o fakturach a predajoch.
- `invoiceline`: Dodatočné informácie k faktúram.
- `mediatype`: Dodatočné informácie o type média skladby.
 
---
### **1.1 Dátová architektúra**

 Dáta sú usporiadané v relačnom modeli, ktorý je znázornený na **entitno-relačnom diagrame (ERD)**:

<p align="center">
  <img src="https://github.com/PalcivaPapricka/DT_projekt_chinook/blob/main/Chinook_ERD.png" alt="ERD Schema">
  <br>
  <em> Entitno-relačná schéma Chinook </em>
</p>

---
## **2 Dimenzionálny model**



---
## **3. ETL proces v Snowflake**

### **3.1 Extract (Extrahovanie dát)**


### **3.2 Transfor (Transformácia dát)**

### **3.3 Load (Načítanie dát)**
---
## **4 Vizualizácia dát**

