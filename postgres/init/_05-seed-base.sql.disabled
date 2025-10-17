-- Seed Frequency Group
INSERT INTO vpv4.FREQUENCIES (FREQUENCY_GROUP) VALUES ('Meget almindelige (> 10 %)');
INSERT INTO vpv4.FREQUENCIES (FREQUENCY_GROUP) VALUES ('Almindelige (1-10 %)');
INSERT INTO vpv4.FREQUENCIES (FREQUENCY_GROUP) VALUES ('Ikke almindelige (0,1-1 %)');
INSERT INTO vpv4.FREQUENCIES (FREQUENCY_GROUP) VALUES ('Sjældne (0,01-0,1 %)');
INSERT INTO vpv4.FREQUENCIES (FREQUENCY_GROUP) VALUES ('Meget sjældne (< 0,01 %)');
INSERT INTO vpv4.FREQUENCIES (FREQUENCY_GROUP) VALUES ('Ikke kendt hyppighed');


-- ORGANS - including hierarchy

insert into vpv4.ORGANS(ORGAN_NAME, ORGAN_TYPE)
values ('Kroppen', 'root');
-- Hoved
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'Hoved', 'MainOrgan');
-- Hoved sub organs
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'Balanceorganet', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'Bihulerne', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'Næse', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'CNS', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'Øre', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'Mund', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'Kæbe', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'Ansigt', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hoved'), 'Kraniet', 'SubOrgan');
-- End Hoved
-- Thorax
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'Thorax', 'MainOrgan');
-- Thorax sub organs
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Thorax'), 'Brystet', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Thorax'), 'Lunge', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Thorax'), 'Hjerte', 'SubOrgan');
-- End Thorax
-- Abdomen
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'Abdomen', 'MainOrgan');
-- Abdomen sub organs
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Lever', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Pankreas', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Tarmene', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Galdeblæren & galdevejene', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Nyrene og binyrene', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Kvindelige kønsorganer', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Urinvejene', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Mavesækken', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Spiserøret', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Abdomen'), 'Milten', 'SubOrgan');
-- End Abdomen
-- Hud
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'Hud', 'MainOrgan');
-- Hud sub organs
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hud'), 'Hår', 'SubOrgan');
-- End Hud
-- PNS
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'PNS', 'MainOrgan');
-- PNS sub organs
-- N/A
-- End PNS
-- Bevægeapparatet
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'Bevægeapparatet', 'MainOrgan');
-- Bevægeapparatet sub organs
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Bevægeapparatet'), 'Ryg', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Bevægeapparatet'), 'Knoglemarv', 'SubOrgan');
-- End Bevægeapparatet
-- Kar
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'Kar', 'MainOrgan');
-- Kar sub organs
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kar'), 'Blodkar', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kar'), 'Lymfesystemet', 'SubOrgan');
-- End kar
-- Mandlige Kønsorganer
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'Mandlige Kønsorganer', 'MainOrgan');
-- Mandlige kønsorganer sub organs
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Mandlige Kønsorganer'), 'Penis', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Mandlige Kønsorganer'), 'Testikler', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Mandlige Kønsorganer'), 'Prostata', 'SubOrgan');
-- End Mandlige kønsorganer
-- Hals
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Kroppen'), 'Hals', 'MainOrgan');
-- Hals sub organs
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hals'), 'Strube', 'SubOrgan');
insert into vpv4.ORGANS (PARENT_ORGAN_ID, ORGAN_NAME, ORGAN_TYPE)
values ((SELECT o.ORGAN_ID FROM vpv4.ORGANS o WHERE o.ORGAN_NAME = 'Hals'), 'Thyroidea & parathyroidea', 'SubOrgan');
-- End Hals

-- Inserting specialties
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Akutmedicin');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Allergologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Anæstesi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Dermatologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Endokrinologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Gynækologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Hæmatologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Infektionsmedicin');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Kæbekirurgi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Kardiologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Karkirurgi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Lungemedicin');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Mave-tarm');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Nefrologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Neurologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Obstetrik');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Onkologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Opthalmologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Øre-næse-hals');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Ortopædi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Pædiatri');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Plastikkirurgi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Psykiatri');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Reumatologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Sexologi');
INSERT INTO vpv4.SPECIALTIES (AREA) VALUES ('Urologi');

INSERT INTO vpv4.PARA_CLINICS (PARA_CLINIC_NAME) VALUES ('Blodprøve');
INSERT INTO vpv4.PARA_CLINICS (PARA_CLINIC_NAME) VALUES ('Blodtryk');
INSERT INTO vpv4.PARA_CLINICS (PARA_CLINIC_NAME) VALUES ('EEG');
INSERT INTO vpv4.PARA_CLINICS (PARA_CLINIC_NAME) VALUES ('EKG');
INSERT INTO vpv4.PARA_CLINICS (PARA_CLINIC_NAME) VALUES ('Saturation');
INSERT INTO vpv4.PARA_CLINICS (PARA_CLINIC_NAME) VALUES ('Temperatur');
INSERT INTO vpv4.PARA_CLINICS (PARA_CLINIC_NAME) VALUES ('Urinstix');

