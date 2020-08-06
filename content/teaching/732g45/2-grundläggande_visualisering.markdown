---
# Course title, summary, and position.
weight: 3

# Page metadata.
title: Grundläggande visualisering
linktitle: Grundläggande visualisering
date: "2020-08-05"
lastmod: "2020-08-05"
draft: false  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: docs  # Do not modify.

tags:
- Swedish
- Programming
- R
- Visualization

# Add menu entry to sidebar.
# - name: Declare this menu item as a parent with ID `name`.
# - weight: Position of link in menu.
menu:
  732G45:
    name: Grundläggande visualisering
    parent: 732G45
    weight: 3
---




## Grundläggande begrepp
Ett diagram innehåller olika delar som kommer refereras i resterande text. Här följer en kortare ordlista:

- **Diagramyta**: Det område som innehåller all information tillhörande en visualisering
- **Rityta**: Det område som innehåller det faktiska data som visualiseras
- **Axel**: Kanterna som begränsar ritytan, ofta benämnt som x- och y-axel för den vågräta ( - ) respektive lodräta ( | ) axeln
- **Axelförklaring**: En rubrik som beskriver vad den angivna axeln visar för information
- **Skalvärden**: Steg som anger specifika värden på den angivna axeln
- **Stödlinjer**: Linjer vilka agerar som en förlängning av axlarnas skalvärden i bakgrunden av ritytan
- **Titel/rubrik**: En rubrik för diagrammet
- **Källhänvisning**: En text placerade i någon av de nedre hörnen som anger en källa för det visualiserade datamaterialet om sådan finns

## Ett bra diagram
För att skapa ett bra diagram behöver man tänka på flera olika saker.

Vilken typ av variabel som ska visualiseras påverkar huruvida ett diagram är tydligt eller inte. Samma sorts diagram kan mycket enkelt och tydligt visualisera en kvalitativ variabel men värdelöst visualisera kvantitativa variabler...

<div class="figure" style="text-align: center">
<img src="/teaching/732g45/2-grundläggande_visualisering_files/figure-html/unnamed-chunk-1-1.png" alt="Figur  1: Exempel på stapeldiagram för en kvalitativ (t.vä.) och kvantitativ (t.hö.) variabel" width="768" />
<p class="caption">1: Figur  1: Exempel på stapeldiagram för en kvalitativ (t.vä.) och kvantitativ (t.hö.) variabel</p>
</div>

Ritytan innehåller den information som ska förmedlas och bör därför få ta upp majoriteten av platsen i ett diagram. Om man anger för stora rubriker blir det lätt att man inkräktar på ritytan. Detsamma gäller om y-axeln innehåller långa skalvärdesnamn.

<div class="figure" style="text-align: center">
<img src="/teaching/732g45/2-grundläggande_visualisering_files/figure-html/unnamed-chunk-2-1.png" alt="Figur  2: Exempel på diagram med majoriteten rityta (t.vä.) och för liten rityta (t.hö.)" width="768" />
<p class="caption">2: Figur  2: Exempel på diagram med majoriteten rityta (t.vä.) och för liten rityta (t.hö.)</p>
</div>

Stödlinjer bör finnas för att underlätta utläsningen av information långt från respektive axel. Dessa bör dock inte ta över diagrammet utan enbart finnas i bakgrunden. Notera att stödlinjer kan komma att justera beroende på vilket sammanhang diagrammen används till. Beroende på upplösning, ljusstyrka eller andra skärmegenskaper kan ibland ljusa och smala linjer försvinna in i den vita bakgrunden. Då är tjockare och starkare stödlinjer befogat.

<div class="figure" style="text-align: center">
<img src="/teaching/732g45/2-grundläggande_visualisering_files/figure-html/unnamed-chunk-3-1.png" alt="Figur  3: Exempel på stödlinjer som ligger i bakgrunden (t.vä.) och stödlinjer som stjäl fokus från informationen (t.hö.)" width="768" />
<p class="caption">3: Figur  3: Exempel på stödlinjer som ligger i bakgrunden (t.vä.) och stödlinjer som stjäl fokus från informationen (t.hö.)</p>
</div>

Ett bra diagram har också läsbar text oavsett storleken på diagrammet. En bra referens kan vara att förhålla den minsta texten i diagrammet till ungefär samma storlek som brödtexten i rapporten eller presentationen. Försök att alltid tänka på att underlätta för läsaren!

<div class="figure" style="text-align: center">
<img src="/teaching/732g45/2-grundläggande_visualisering_files/figure-html/unnamed-chunk-4-1.png" alt="Figur  4: Exempel på läsbar text (t.vä.) och på gränsen till för liten text (t.hö.)" width="768" />
<p class="caption">4: Figur  4: Exempel på läsbar text (t.vä.) och på gränsen till för liten text (t.hö.)</p>
</div>

Källhänvisning bör finnas i alla diagram där informationen är hämtat från någon annan källa än oss själva. 

<div class="figure" style="text-align: center">
<img src="/teaching/732g45/2-grundläggande_visualisering_files/figure-html/unnamed-chunk-5-1.png" alt="Figur  5: Exempeldiagram med källhänvisning" width="384" />
<p class="caption">5: Figur  5: Exempeldiagram med källhänvisning</p>
</div>
