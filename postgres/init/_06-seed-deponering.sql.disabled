-- =====================================================
-- Seed Data for Seponeringslisten 2025
-- Source: Sundhedsstyrelsen - Danish Health Authority
-- Version: 2025-01-01
-- =====================================================

-- Insert top-level ATC codes if they don't exist
INSERT INTO vpv4.ATC_CODES (ATC_CODE, DESCRIPTION, ATC_LEVEL, PARENT_CODE)
VALUES 
    ('A', 'Alimentary tract and metabolism', 1, NULL),
    ('B', 'Blood and blood forming organs', 1, NULL),
    ('C', 'Cardiovascular system', 1, NULL),
    ('G', 'Genito urinary system and sex hormones', 1, NULL),
    ('J', 'Antiinfectives for systemic use', 1, NULL),
    ('M', 'Musculo-skeletal system', 1, NULL),
    ('N', 'Nervous system', 1, NULL),
    ('R', 'Respiratory system', 1, NULL)
ON CONFLICT (ATC_CODE) DO NOTHING;

-- =====================================================
-- INSERT ACTIVE SUBSTANCES
-- =====================================================

-- Group A - Alimentary tract and metabolism
INSERT INTO vpv4.ACTIVE_SUBSTANCES (SUBSTANCE_NAME, ATC_CODE_ID) VALUES
    ('Esomeprazol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'A')),
    ('Lansoprazol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'A')),
    ('Omeprazol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'A')),
    ('Pantoprazol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'A')),
    ('Rabeprazol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'A')),
    ('Metoclopramid', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'A')),
    ('Domperidon', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'A'));

-- Group B - Blood and blood forming organs
INSERT INTO vpv4.ACTIVE_SUBSTANCES (SUBSTANCE_NAME, ATC_CODE_ID) VALUES
    ('Acetylsalicylsyre', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'B'));

-- Group C - Cardiovascular system
INSERT INTO vpv4.ACTIVE_SUBSTANCES (SUBSTANCE_NAME, ATC_CODE_ID) VALUES
    ('Isosorbidmononitrat', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Isosorbiddinitrat', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Bumetanid', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Furosemid', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Metoprolol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Carvedilol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Bisoprolol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Atorvastatin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Simvastatin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C')),
    ('Rosuvastatin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'C'));

-- Group G - Genitourinary system and sex hormones
INSERT INTO vpv4.ACTIVE_SUBSTANCES (SUBSTANCE_NAME, ATC_CODE_ID) VALUES
    ('Ethinylestradiol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Estradiol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Estriol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Solifenacin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Tolterodin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Fesoterodin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Trospiumchlorid', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Mirabegron', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Dutasterid', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G')),
    ('Finasterid', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'G'));

-- Group J - Antiinfectives for systemic use
INSERT INTO vpv4.ACTIVE_SUBSTANCES (SUBSTANCE_NAME, ATC_CODE_ID) VALUES
    ('Pivmecillinam', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'J')),
    ('Sulfamethizol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'J')),
    ('Trimethoprim', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'J')),
    ('Nitrofurantoin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'J'));

-- Group M - Musculo-skeletal system
INSERT INTO vpv4.ACTIVE_SUBSTANCES (SUBSTANCE_NAME, ATC_CODE_ID) VALUES
    ('Ibuprofen', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M')),
    ('Naproxen', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M')),
    ('Diclofenac', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M')),
    ('Celecoxib', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M')),
    ('Chlorzoxazon', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M')),
    ('Baklofen', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M')),
    ('Tizanidin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M')),
    ('Alendronat', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M')),
    ('Risedronat', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'M'));

-- Group N - Nervous system
INSERT INTO vpv4.ACTIVE_SUBSTANCES (SUBSTANCE_NAME, ATC_CODE_ID) VALUES
    ('Tramadol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Kodein', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Morfin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Oxycodon', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Fentanyl', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Buprenorphin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Paracetamol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Pregabalin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Gabapentin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Diazepam', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Oxazepam', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Alprazolam', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Zopiclon', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Zolpidem', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Haloperidol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Risperidon', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Olanzapin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Quetiapin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Sertralin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Citalopram', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Duloxetin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Venlafaxin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Mirtazapin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Nortriptylin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Donepezil', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Galantamin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Memantin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Rivastigmin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Pramipexol', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Promethazin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Cyclizin', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N')),
    ('Atarax', (SELECT ATC_CODE_ID FROM vpv4.ATC_CODES WHERE ATC_CODE = 'N'));

-- =====================================================
-- INSERT DEPRESCRIBING GUIDELINES
-- =====================================================

-- Group A - Proton Pump Inhibitors
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér ved: Funktionel dyspepsi (symptomer uden organisk forklaring). Ukompliceret ulcus (ingen blødning eller perforation), når patienten er symptomfri (tager op til 4 uger). Ophør af lægemidler, hvor PPI alene er givet som ulcusprofylakse (fx NSAID (inkl. ASA), prednisolon og SSRI).',
    'Kan seponeres uden aftrapning eller ved aftrapning, hvor dosis halveres (fx hver 2. uge). Efter behandling i mere end 4-8 uger kan der forekomme øget syresekretion (rebound). Brug i disse tilfælde syreneutraliserende midler p.n. i en periode.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Esomeprazol', 'Lansoprazol', 'Omeprazol', 'Pantoprazol', 'Rabeprazol');

-- Antiemetics
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
VALUES
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Metoclopramid'),
     'Seponér: Metoclopramid inden for 5 dage.',
     'Kan seponeres uden aftrapning - både efter fast og p.n.-behandling.',
     FALSE, TRUE, '2025-01-01', TRUE),
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Domperidon'),
     'Seponér: Domperidon inden for 7 dage.',
     'Kan seponeres uden aftrapning - både efter fast og p.n.-behandling.',
     FALSE, FALSE, '2025-01-01', TRUE);

-- Group B - Antiplatelet therapy
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
VALUES
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Acetylsalicylsyre'),
     'Seponér ved: Fravær af manifest kardiovaskulær sygdom og/eller diabetes. Overvej seponering: Af enten trombocythæmmer eller antikoagulerende behandling, hvis der ikke er lagt en plan for det (ved kombination med koagulationshæmmende eller trombocythæmmende midler).',
     'Kan seponeres uden aftrapning.',
     FALSE, FALSE, '2025-01-01', TRUE);

-- Group C - Long-acting nitrates
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Overvej seponering ved: Stabil iskæmisk hjertesygdom uden symptomer (typisk 1-6 måneder efter revaskularisering).',
    'Kan seponeres uden aftrapning. Fortsæt p.n.-behandling med hurtigtvirkende nitroglycerin.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Isosorbidmononitrat', 'Isosorbiddinitrat');

-- Loop diuretics
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér: Som monoterapi ved ukompliceret hypertension. Ved perifere ødemer uden organspecifik årsag. Nedtrap til lavest mulige dosis ved: Hjerteinsufficiens. Effekten er kun symptomatisk.',
    'Bør seponeres ved aftrapning, pga. risiko for væskeophobning (rebound). Husk vægt- og elektrolytkontrol og hold øje med evt. recidiv af inkompensation. Vær obs. på justering af kaliumtilskud ved seponering eller reduktion af dosis.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Bumetanid', 'Furosemid');

-- Beta blockers
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér: Senest 2 år efter akut myokardieinfarkt (AMI) med ST-elevation (STEMI), medmindre der findes andre grunde til at fortsætte behandlingen (fx systolisk hjertesvigt). Som monoterapi ved ukompliceret hypertension.',
    'Bør seponeres ved aftrapning over 1-2 uger pga. risiko for seponeringssyndrom (takykardi, hovedpine, svedeture og trykken i brystet).',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Metoprolol', 'Carvedilol', 'Bisoprolol');

-- Statins
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér ved: Kort forventet restlevetid og/eller svær skrøbelighed. Overvej seponering ved: Primær profylakse og samtidig lav risiko for at dø af kardiovaskulær sygdom ud fra en samlet risikovurdering.',
    'Kan seponeres uden aftrapning.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Atorvastatin', 'Simvastatin', 'Rosuvastatin');

-- Group G - Hormonal contraception
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
VALUES
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Ethinylestradiol'),
     'Seponér ved: Alvorlige risikofaktorer (herunder migræne med aura) for arteriel eller venøs tromboembolisk sygdom. Alder over 40 år.',
     'Kan seponeres uden aftrapning. Vejled i alternative præventionsformer fx gestagen-alene præparater.',
     FALSE, FALSE, '2025-01-01', TRUE);

-- Hormone replacement therapy
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér ved: En samlet behandlingsvarighed på 5 år eller derover.',
    'Bør seponeres ved dosisreduktion på 25-50% hver 2.-4. uge.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Estradiol', 'Estriol');

-- Bladder spasmolytics (with anticholinergic effects)
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér ved: Manglende effekt efter 1-2 måneders behandling. Permanent kateter. Overvej seponering ved: Langvarig behandling. Behandlingen bør én gang om året pauseres i 3 uger med henblik på revurdering af effekt.',
    'Kan seponeres uden aftrapning.',
    FALSE,
    TRUE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Solifenacin', 'Tolterodin', 'Fesoterodin', 'Trospiumchlorid');

-- Mirabegron (non-anticholinergic)
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
VALUES
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Mirabegron'),
     'Seponér ved: Manglende effekt efter 1-2 måneders behandling. Permanent kateter. Overvej seponering ved: Langvarig behandling. Behandlingen bør én gang om året pauseres i 3 uger med henblik på revurdering af effekt.',
     'Kan seponeres uden aftrapning.',
     FALSE, FALSE, '2025-01-01', TRUE);

-- 5α-reductase inhibitors
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér ved: Manglende effekt efter 12 måneders behandling.',
    'Kan seponeres uden aftrapning.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Dutasterid', 'Finasterid');

-- Group J - Antibiotics
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Overvej seponering ved: Forebyggelse af urinvejsinfektioner.',
    'Kan seponeres uden aftrapning.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Pivmecillinam', 'Sulfamethizol', 'Trimethoprim', 'Nitrofurantoin');

-- Group M - NSAIDs
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér ved: Kroniske smerter uden inflammatorisk komponent. Svært nedsat nyre- eller leverfunktion. Svær hjerteinsufficiens og/eller svær iskæmisk hjertesygdom. Blødningstendens (fx ved AK-behandling). Overvej seponering ved: Ældre eller skrøbelige patienter. Hjertekarsygdom eller høj risiko herfor. Høj risiko for ulcuskomplikation. Samtidig behandling med andre lægemidler, som øger blødningsrisikoen. Samtidig behandling med diuretika og ACE-hæmmere/AT-II-antagonister pga. risiko for nyresvigt (triple whammy).',
    'Kan seponeres uden aftrapning.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Ibuprofen', 'Naproxen', 'Diclofenac', 'Celecoxib');

-- Muscle relaxants
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
VALUES
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Chlorzoxazon'),
     'Seponér ved: Akut, uspecifikt lændehold. Overvej seponering ved: Øvrige tilstande.',
     'Chlorzoxazon kan seponeres uden aftrapning.',
     TRUE, FALSE, '2025-01-01', TRUE),
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Baklofen'),
     'Seponér ved: Akut, uspecifikt lændehold. Overvej seponering ved: Øvrige tilstande.',
     'Baklofen bør aftrappes over 1-2 uger.',
     TRUE, TRUE, '2025-01-01', TRUE),
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Tizanidin'),
     'Seponér ved: Akut, uspecifikt lændehold. Overvej seponering ved: Øvrige tilstande.',
     'Tizanidin bør aftrappes over 1-2 uger.',
     TRUE, TRUE, '2025-01-01', TRUE);

-- Bisphosphonates
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér: 6-12 måneder efter ophør af systemisk glukokortikoidbehandling, hvis T-score er > -2,5, og patienten ikke har haft lavenergifraktur. Overvej seponering: Efter minimum 5 år ved knogleskørhed, hvis patienten aldrig har haft lavenergifraktur i columna eller hofte, og T-score (i hoften) efter behandlingen er > -2,5, og der ikke har været øvrige lavenergifrakturer i perioden. Ved kort forventet restlevetid og/eller svær skrøbelighed.',
    'Kan seponeres uden aftrapning. Overvej at kontrollere BMD (knoglevævets mineraltæthed) 2 år efter behandlingsophør.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Alendronat', 'Risedronat');

-- Group N - Opioids (all with traffic warning)
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér: Fast dosering af hurtigtvirkende opioider (inkl. kodein og tramadol). Anvend i stedet depotmorfin (bedre døgndækning, mindre euforiserende effekt). Smerteplastre, hvis patienten kan tage tabletter (Plastre har større variation i biotilgængelighed og flere utilsigtede hændelser). Opioider mod kroniske, non-maligne smerter pga. bivirkninger og sparsom evidens for effekt.',
    'Seponér ved aftrapning efter en individuel plan. Efter kortvarig behandling (mindre end 6 uger): Reducér døgndosis med 10-20% hver 3.-5. dag. Efter langvarig behandling: Reducér døgndosis med 5-20% med ca. 2 ugers mellemrum. Giv ikke oralt opioid inden for ca. 18 timer efter fjernelse af fentanylplastre og ca. 24 timer efter buprenorphin-plastre. Klip ikke depotplastre over. Begræns dosis til max 100 mg morfinækvivalenter per døgn. Justér laksantia ved seponering eller reduktion af dosis.',
    TRUE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Tramadol', 'Kodein', 'Morfin', 'Oxycodon', 'Fentanyl', 'Buprenorphin');

-- Paracetamol
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
VALUES
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Paracetamol'),
     'Overvej seponering ved: Langtidsbehandling.',
     'Kan seponeres uden aftrapning eller ved hjælp af en tidsbegrænset p.n.-ordination.',
     FALSE, FALSE, '2025-01-01', TRUE);

-- Gabapentinoids (with traffic warning)
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér: Inden for 4 uger ved behandling af akut belastningsreaktion eller tilpasningsreaktion med angst- og urosymptomer. Overvej seponering ved: Langvarig smertebehandling. Generaliseret angst: Efter ½-1 års behandling med god effekt.',
    'Efter kortvarig behandling (almindeligvis 1-2 uger og højst 4 uger) seponeres ved aftrapning over få dage. Efter langvarig behandling aftrappes dosis langsomt (uger til måneder). Ved seponeringssymptomer aftrappes langsommere, især sidst i forløbet.',
    TRUE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Pregabalin', 'Gabapentin');

-- Benzodiazepines and Z-drugs (all with traffic warning)
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér: Inden for 4 uger ved behandling af akut belastningsreaktion eller tilpasningsreaktion med angst- og urosymptomer. Langtidsbehandling med benzodiazepin kan dog være indiceret ved behandlingsrefraktær angst. Inden for 2 uger ved behandling af søvnbesvær, pga. udvikling af tolerans, afhængighed og vedvarende kognitive bivirkninger.',
    'Efter kortvarig behandling (almindeligvis 1-2 uger og højst 4 uger) seponeres ved aftrapning over få dage. Efter langvarig behandling aftrappes dosis langsomt (uger til måneder). Brug evt. tabletdeler eller medicinfri dage. Ved seponeringssymptomer aftrappes langsommere, især sidst i forløbet.',
    TRUE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Diazepam', 'Oxazepam', 'Alprazolam', 'Zopiclon', 'Zolpidem');

-- Antipsychotics (with anticholinergic effects)
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér: Inden for 3 måneder, hvis behandlingen undtagelsesvis er givet imod adfærdsforstyrrelser ved demens pga. stor risiko for bivirkninger og øget dødelighed. Ved delir, da antipsykotika muligvis ikke nedsætter varighed af delirium eller mindsker uro. Inden for 4 ugers behandling af akut belastningsreaktion eller tilpasningsreaktion med angst- og urosymptomer, da der er betydelig risiko for bivirkninger, trods behandling i lave doser.',
    'Seponér ved aftrapning. Ved lave doser kan aftrapning ofte være kortvarig.',
    FALSE,
    TRUE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Haloperidol', 'Risperidon', 'Olanzapin', 'Quetiapin');

-- Antidepressants
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponer: Sederende antidepressiva givet for søvnbesvær inden for 2-4 ugers behandling. Overvej seponering ved: Depression: Efter ½-1 års symptomfrihed ved første depressive episode eller mindst 2 år efter symptomfrihed ved én eller flere tidligere depressioner eller tilstedeværelse af andre risikofaktorer for tilbagefald. Angstlidelse: Efter ½-1 års behandling med god effekt. Demens uden kendt affektiv sygdom: inden for ½ års behandling.',
    'Seponér ved langsom aftrapning over én til flere måneder efter en individuel plan. Reducer dosis med fx 25-50% med 1-2 ugers mellemrum. Brug evt. tabletdeler. Ved seponeringssymptomer: Forlæng tiden mellem dosisreduktionerne eller foretag langsommere dosisreduktion. Kan især være nødvendigt sidst i forløbet.',
    FALSE,
    CASE WHEN SUBSTANCE_NAME IN ('Mirtazapin', 'Nortriptylin') THEN TRUE ELSE FALSE END,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Sertralin', 'Citalopram', 'Duloxetin', 'Venlafaxin', 'Mirtazapin', 'Nortriptylin');

-- Dementia medications
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér ved: Meget svær demens (fx sengeliggende uden sprog). Overvej seponering ved: Demens og tvivl om mærkbar behandlingseffekt. Svær skrøbelighed og/eller kort restlevetid.',
    'Kan seponeres uden aftrapning. Genoptag behandlingen ved optitrering i samråd med pårørende/plejepersonale ved markant forværring inden for 2-4 uger efter seponering.',
    FALSE,
    FALSE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Donepezil', 'Galantamin', 'Memantin', 'Rivastigmin');

-- Pramipexol (with AC)
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
VALUES
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Pramipexol'),
     'Seponér ved: Uro i benene og Restless legs syndrom (RLS).',
     'Kan seponeres uden aftrapning ved de normale doser ≤ 0.54mg til RLS.',
     FALSE, TRUE, '2025-01-01', TRUE);

-- Sedating antihistamines (with both traffic warning and anticholinergic effects)
INSERT INTO vpv4.DEPRESCRIBING_GUIDELINES (ACTIVE_SUBSTANCE_ID, WHEN_TO_DEPRESCRIBE, HOW_TO_DEPRESCRIBE, TRAFFIC_WARNING, ANTICHOLINERGIC_EFFECT, GUIDELINE_VERSION, IS_CURRENT)
SELECT 
    ACTIVE_SUBSTANCE_ID,
    'Seponér ved: Søvnløshed. Angst og uro.',
    'Kan seponeres uden aftrapning.',
    TRUE,
    TRUE,
    '2025-01-01',
    TRUE
FROM vpv4.ACTIVE_SUBSTANCES 
WHERE SUBSTANCE_NAME IN ('Promethazin', 'Cyclizin', 'Atarax');

-- =====================================================
-- INSERT COMMON SUBSTANCE SYNONYMS
-- =====================================================

INSERT INTO vpv4.SUBSTANCE_SYNONYMS (ACTIVE_SUBSTANCE_ID, SYNONYM_NAME) VALUES
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Acetylsalicylsyre'), 'ASA'),
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Acetylsalicylsyre'), 'Aspirin'),
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Acetylsalicylsyre'), 'Acetylsalicylic acid'),
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Ethinylestradiol'), 'Ethinylœstradiol'),
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Metoprolol'), 'Metoprolol succinate'),
    ((SELECT ACTIVE_SUBSTANCE_ID FROM vpv4.ACTIVE_SUBSTANCES WHERE SUBSTANCE_NAME = 'Metoprolol'), 'Metoprolol tartrate');

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Count of substances by ATC group
SELECT 
    ac.ATC_CODE,
    ac.DESCRIPTION,
    COUNT(asub.ACTIVE_SUBSTANCE_ID) as substance_count
FROM vpv4.ATC_CODES ac
LEFT JOIN vpv4.ACTIVE_SUBSTANCES asub ON ac.ATC_CODE_ID = asub.ATC_CODE_ID
WHERE ac.ATC_LEVEL = 1
GROUP BY ac.ATC_CODE, ac.DESCRIPTION
ORDER BY ac.ATC_CODE;

-- Substances with traffic warnings or anticholinergic effects
SELECT 
    COUNT(DISTINCT asub.ACTIVE_SUBSTANCE_ID) as total_substances,
    COUNT(DISTINCT CASE WHEN dg.TRAFFIC_WARNING THEN asub.ACTIVE_SUBSTANCE_ID END) as with_traffic_warning,
    COUNT(DISTINCT CASE WHEN dg.ANTICHOLINERGIC_EFFECT THEN asub.ACTIVE_SUBSTANCE_ID END) as with_anticholinergic
FROM vpv4.ACTIVE_SUBSTANCES asub
LEFT JOIN vpv4.DEPRESCRIBING_GUIDELINES dg ON asub.ACTIVE_SUBSTANCE_ID = dg.ACTIVE_SUBSTANCE_ID
WHERE dg.IS_CURRENT = TRUE;

-- Total guidelines count
SELECT COUNT(*) as total_guidelines FROM vpv4.DEPRESCRIBING_GUIDELINES WHERE IS_CURRENT = TRUE;