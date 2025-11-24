INSERT INTO public."ref-alteration" VALUES
  (1, '(Missense) SNV'),
  (2, 'Nonsense SNV'),
  (3, 'Splice SNV'),
  (4, '(Frameshift) indel'),
  (6, 'Splice indel'),
  (7, 'Fusion'),
  (8, 'Deletion'),
  (9, 'Gain'),
  (10, 'Amplification'),
  (11, 'Overexpression'),
  (12, '(Internal) tandem duplication'),
  (13, 'Structural variant'),
  (14, 'Signature'),
  (99, 'Alteration'),
  (999, 'No detection')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-functional_consequence" VALUES
  (0, 'Loss of function'),
  (1, 'Gain of function'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-anticoagulant" VALUES
  (1, 'Li-Heparin'),
  (2, 'EDTA'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-biological_process" VALUES
  (1, 'Cell death'),
  (2, 'Cell cycle'),
  (3, 'Cell migration/adhesion'),
  (4, 'Differentiation/Epigenetic regulation'),
  (5, 'Immune regulation'),
  (6, 'RAS/RAF/MAPK signaling'),
  (7, 'PI3K/mTOR/AKT signaling'),
  (8, 'RTK signaling'),
  (9, 'ABL signaling'),
  (10, 'JAK/STAT signaling'),
  (11, 'Transcription'),
  (12, 'Protein turnover'),
  (13, 'Protein transport'),
  (14, 'Metabolism'),
  (15, 'DNA replication/damage/repair'),
  (16, 'Translation'),
  (17, 'TGFbeta signaling'),
  (18, 'Notch signaling'),
  (19, 'RNA splicing'),
  (99, 'Other'),
  (999, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-cell_isolation" VALUES
  (1, 'Ficoll'),
  (2, 'RBC lysis'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-country" (id,description,description_capitalized,iso_alpha2,iso_alpha3,iso_numeric) VALUES
  (1,'Afghanistan','AFGHANISTAN','AF','AFG',4),
  (2,'Aland Islands','ALANDISLANDS','AX','ALA',248),
  (3,'Albania','ALBANIA','AL','ALB',8),
  (4,'Algeria','ALGERIA','DZ','DZA',12),
  (5,'American Samoa','AMERICANSAMOA','AS','ASM',16),
  (6,'Andorra','ANDORRA','AD','AND',20),
  (7,'Angola','ANGOLA','AO','AGO',24),
  (8,'Anguilla','ANGUILLA','AI','AIA',660),
  (9,'Antarctica','ANTARCTICA','AQ','ATA',10),
  (10,'Antigua and Barbuda','ANTIGUAANDBARBUDA','AG','ATG',28),
  (11,'Argentina','ARGENTINA','AR','ARG',32),
  (12,'Armenia','ARMENIA','AM','ARM',51),
  (13,'Aruba','ARUBA','AW','ABW',533),
  (14,'Australia','AUSTRALIA','AU','AUS',36),
  (15,'Austria','AUSTRIA','AT','AUT',40),
  (16,'Azerbaijan','AZERBAIJAN','AZ','AZE',31),
  (17,'Bahamas','BAHAMAS','BS','BHS',44),
  (18,'Bahrain','BAHRAIN','BH','BHR',48),
  (19,'Bangladesh','BANGLADESH','BD','BGD',50),
  (20,'Barbados','BARBADOS','BB','BRB',52),
  (21,'Belarus','BELARUS','BY','BLR',112),
  (22,'Belgium','BELGIUM','BE','BEL',56),
  (23,'Belize','BELIZE','BZ','BLZ',84),
  (24,'Benin','BENIN','BJ','BEN',204),
  (25,'Bermuda','BERMUDA','BM','BMU',60),
  (26,'Bhutan','BHUTAN','BT','BTN',64),
  (27,'Bolivia','BOLIVIA','BO','BOL',68),
  (28,'Bonaire Sint Eustatius and Saba','BONAIRESINTEUSTATIUSANDSABA','BQ','BES',535),
  (29,'Bosnia and Herzegovina','BOSNIAANDHERZEGOVINA','BA','BIH',70),
  (30,'Botswana','BOTSWANA','BW','BWA',72),
  (31,'Bouvet Island','BOUVETISLAND','BV','BVT',74),
  (32,'Brazil','BRAZIL','BR','BRA',76),
  (33,'British Indian Ocean Territory','BRITISHINDIANOCEANTERRITORY','IO','IOT',86),
  (34,'Brunei Darussalam','BRUNEIDARUSSALAM','BN','BRN',96),
  (35,'Bulgaria','BULGARIA','BG','BGR',100),
  (36,'Burkina Faso','BURKINAFASO','BF','BFA',854),
  (37,'Burundi','BURUNDI','BI','BDI',108),
  (38,'Cambodia','CAMBODIA','KH','KHM',116),
  (39,'Cameroon','CAMEROON','CM','CMR',120),
  (40,'Canada','CANADA','CA','CAN',124),
  (41,'CapeVerde','CAPEVERDE','CV','CPV',132),
  (42,'Cayman Islands','CAYMANISLANDS','KY','CYM',136),
  (43,'Central African Republic','CENTRALAFRICANREPUBLIC','CF','CAF',140),
  (44,'Chad','CHAD','TD','TCD',148),
  (45,'Chile','CHILE','CL','CHL',152),
  (46,'China','CHINA','CN','CHN',156),
  (47,'Christmas Island','CHRISTMASISLAND','CX','CXR',162),
  (48,'Colombia','COLOMBIA','CO','COL',170),
  (49,'Comoros','COMOROS','KM','COM',174),
  (50,'Congo','CONGO','CG','COG',178),
  (51,'Congo Democratic Republic','CONGODEMOCRATICREPUBLIC','CD','COD',180),
  (52,'Cook Islands','COOKISLANDS','CK','COK',184),
  (53,'Costa Rica','COSTARICA','CR','CRI',188),
  (54,'Cote D''Ivoire','COTEDIVOIRE','CI','CIV',384),
  (55,'Croatia','CROATIA','HR','HRV',191),
  (56,'Cuba','CUBA','CU','CUB',192),
  (57,'Curacao','CURACAO','CW','CUW',531),
  (58,'Cyprus','CYPRUS','CY','CYP',196),
  (59,'Czech Republic','CZECHIA','CZ','CZE',203),
  (60,'Denmark','DENMARK','DK','DNK',208),
  (61,'Djibouti','DJIBOUTI','DJ','DJI',262),
  (62,'Dominica','DOMINICA','DM','DMA',212),
  (63,'Dominican Republic','DOMINICANREPUBLIC','DO','DOM',214),
  (64,'Ecuador','ECUADOR','EC','ECU',218),
  (65,'Egypt','EGYPT','EG','EGY',818),
  (66,'El Salvador','ELSALVADOR','SV','SLV',222),
  (67,'Equatorial Guinea','EQUATORIALGUINEA','GQ','GNQ',226),
  (68,'Eritrea','ERITREA','ER','ERI',232),
  (69,'Estonia','ESTONIA','EE','EST',233),
  (70,'Ethiopia','ETHIOPIA','ET','ETH',231),
  (71,'Falkland Islands Malvinas','FALKLANDISLANDSMALVINAS','FK','FLK',238),
  (72,'Faroe Islands','FAROEISLANDS','FO','FRO',234),
  (73,'Fiji','FIJI','FJ','FJI',242),
  (74,'Finland','FINLAND','FI','FIN',246),
  (75,'France','FRANCE','FR','FRA',250),
  (76,'French Guiana','FRENCHGUIANA','GF','GUF',254),
  (77,'French Polynesia','FRENCHPOLYNESIA','PF','PYF',258),
  (78,'French Southern Territories','FRENCHSOUTHERNTERRITORIES','TF','ATF',260),
  (79,'Gabon','GABON','GA','GAB',266),
  (80,'Gambia','GAMBIA','GM','GMB',270),
  (81,'Georgia','GEORGIA','GE','GEO',268),
  (82,'Germany','GERMANY','DE','DEU',276),
  (83,'Ghana','GHANA','GH','GHA',288),
  (84,'Gibraltar','GIBRALTAR','GI','GIB',292),
  (85,'Greece','GREECE','GR','GRC',300),
  (86,'Greenland','GREENLAND','GL','GRL',304),
  (87,'Grenada','GRENADA','GD','GRD',308),
  (88,'Guadeloupe','GUADELOUPE','GP','GLP',312),
  (89,'Guam','GUAM','GU','GUM',316),
  (90,'Guatemala','GUATEMALA','GT','GTM',320),
  (91,'Guernsey','GUERNSEY','GG','GGY',831),
  (92,'Guinea','GUINEA','GN','GIN',324),
  (93,'Guinea-Bissau','GUINEA-BISSAU','GW','GNB',624),
  (94,'Guyana','GUYANA','GY','GUY',328),
  (95,'Haiti','HAITI','HT','HTI',332),
  (96,'Heard Island and Mcdonald Islands','HEARDISLANDANDMCDONALDISLANDS','HM','HMD',334),
  (97,'Holy See Vatican City State','HOLYSEEVATICANCITYSTATE','VA','VAT',336),
  (98,'Honduras','HONDURAS','HN','HND',340),
  (99,'Hong Kong','HONGKONG','HK','HKG',344),
  (100,'Hungary','HUNGARY','HU','HUN',348),
  (101,'Iceland','ICELAND','IS','ISL',352),
  (102,'India','INDIA','IN','IND',356),
  (103,'Indonesia','INDONESIA','ID','IDN',360),
  (104,'Iran','IRAN','IR','IRN',364),
  (105,'Iraq','IRAQ','IQ','IRQ',368),
  (106,'Ireland','IRELAND','IE','IRL',372),
  (107,'IsleofMan','ISLEOFMAN','IM','IMN',833),
  (108,'Israel','ISRAEL','IL','ISR',376),
  (109,'Italy','ITALY','IT','ITA',380),
  (110,'Jamaica','JAMAICA','JM','JAM',388),
  (111,'Japan','JAPAN','JP','JPN',392),
  (112,'Jersey','JERSEY','JE','JEY',832),
  (113,'Jordan','JORDAN','JO','JOR',400),
  (114,'Kazakhstan','KAZAKHSTAN','KZ','KAZ',398),
  (115,'Kenya','KENYA','KE','KEN',404),
  (116,'Kiribati','KIRIBATI','KI','KIR',296),
  (117,'Kosovo','KOSOVO','XK','XKX',0),
  (118,'Kuwait','KUWAIT','KW','KWT',414),
  (119,'Kyrgyzstan','KYRGYZSTAN','KG','KGZ',417),
  (120,'Lao Peoples Democratic Republic','LAOPEOPLESDEMOCRATICREPUBLIC','LA','LAO',418),
  (121,'Latvia','LATVIA','LV','LVA',428),
  (122,'Lebanon','LEBANON','LB','LBN',422),
  (123,'Lesotho','LESOTHO','LS','LSO',426),
  (124,'Liberia','LIBERIA','LR','LBR',430),
  (125,'Libyan Arab Jamahiriya','LIBYANARABJAMAHIRIYA','LY','LBY',434),
  (126,'Liechtenstein','LIECHTENSTEIN','LI','LIE',438),
  (127,'Lithuania','LITHUANIA','LT','LTU',440),
  (128,'Luxembourg','LUXEMBOURG','LU','LUX',442),
  (129,'Macao','MACAO','MO','MAC',446),
  (130,'Madagascar','MADAGASCAR','MG','MDG',450),
  (131,'Malawi','MALAWI','MW','MWI',454),
  (132,'Malaysia','MALAYSIA','MY','MYS',458),
  (133,'Maldives','MALDIVES','MV','MDV',462),
  (134,'Mali','MALI','ML','MLI',466),
  (135,'Malta','MALTA','MT','MLT',470),
  (136,'Marshall Islands','MARSHALLISLANDS','MH','MHL',584),
  (137,'Martinique','MARTINIQUE','MQ','MTQ',474),
  (138,'Mauritania','MAURITANIA','MR','MRT',478),
  (139,'Mauritius','MAURITIUS','MU','MUS',480),
  (140,'Mayotte','MAYOTTE','YT','MYT',175),
  (141,'Mexico','MEXICO','MX','MEX',484),
  (142,'Micronesia Federated States','MICRONESIAFEDERATEDSTATES','FM','FSM',583),
  (143,'Moldova Republic','MOLDOVAREPUBLIC','MD','MDA',498),
  (144,'Monaco','MONACO','MC','MCO',492),
  (145,'Mongolia','MONGOLIA','MN','MNG',496),
  (146,'Montenegro','MONTENEGRO','ME','MNE',499),
  (147,'Montserrat','MONTSERRAT','MS','MSR',500),
  (148,'Morocco','MOROCCO','MA','MAR',504),
  (149,'Mozambique','MOZAMBIQUE','MZ','MOZ',508),
  (150,'Myanmar','MYANMAR','MM','MMR',104),
  (151,'Namibia','NAMIBIA','NA','NAM',516),
  (152,'Nauru','NAURU','NR','NRU',520),
  (153,'Nepal','NEPAL','NP','NPL',524),
  (154,'Netherlands','NETHERLANDS','NL','NLD',528),
  (155,'Netherlands Antilles','NETHERLANDSANTILLES','AN','ANT',530),
  (156,'New Caledonia','NEWCALEDONIA','NC','NCL',540),
  (157,'New Zealand','NEWZEALAND','NZ','NZL',554),
  (158,'Nicaragua','NICARAGUA','NI','NIC',558),
  (159,'Niger','NIGER','NE','NER',562),
  (160,'Nigeria','NIGERIA','NG','NGA',566),
  (161,'Niue','NIUE','NU','NIU',570),
  (162,'Norfolk Island','NORFOLKISLAND','NF','NFK',574),
  (163,'Northern Mariana Islands','NORTHERNMARIANAISLANDS','MP','MNP',580),
  (164,'NorthKorea','NORTHKOREA','KP','PRK',408),
  (165,'North Macedonia','NORTHMACEDONIA','MK','MKD',807),
  (166,'Norway','NORWAY','NO','NOR',578),
  (167,'Oman','OMAN','OM','OMN',512),
  (168,'Pakistan','PAKISTAN','PK','PAK',586),
  (169,'Palau','PALAU','PW','PLW',585),
  (170,'Panama','PANAMA','PA','PAN',591),
  (171,'Papua New Guinea','PAPUANEWGUINEA','PG','PNG',598),
  (172,'Paraguay','PARAGUAY','PY','PRY',600),
  (173,'Peru','PERU','PE','PER',604),
  (174,'Philippines','PHILIPPINES','PH','PHL',608),
  (175,'Pitcairn','PITCAIRN','PN','PCN',612),
  (176,'Poland','POLAND','PL','POL',616),
  (177,'Portugal','PORTUGAL','PT','PRT',620),
  (178,'Puerto Rico','PUERTORICO','PR','PRI',630),
  (179,'Qatar','QATAR','QA','QAT',634),
  (180,'Reunion','REUNION','RE','REU',638),
  (181,'Romania','ROMANIA','RO','ROU',642),
  (182,'Russian Federation','RUSSIANFEDERATION','RU','RUS',643),
  (183,'Rwanda','RWANDA','RW','RWA',646),
  (184,'Saint Barthelemy','SAINTBARTHELEMY','BL','BLM',652),
  (185,'Saint Helena','SAINTHELENA','SH','SHN',654),
  (186,'Saint Kitts and Nevis','SAINTKITTSANDNEVIS','KN','KNA',659),
  (187,'Saint Lucia','SAINTLUCIA','LC','LCA',662),
  (188,'Saint Martin','SAINTMARTIN','MF','MAF',663),
  (189,'Saint Pierre and Miquelon','SAINTPIERREANDMIQUELON','PM','SPM',666),
  (190,'Saint Vincent and the Grenadines','SAINTVINCENTANDTHEGRENADINES','VC','VCT',670),
  (191,'Samoa','SAMOA','WS','WSM',882),
  (192,'SanMarino','SANMARINO','SM','SMR',674),
  (193,'Sao Tome and Principe','SAOTOMEANDPRINCIPE','ST','STP',678),
  (194,'SaudiArabia','SAUDIARABIA','SA','SAU',682),
  (195,'Senegal','SENEGAL','SN','SEN',686),
  (196,'Serbia','SERBIA','RS','SRB',688),
  (197,'Seychelles','SEYCHELLES','SC','SYC',690),
  (198,'SierraLeone','SIERRALEONE','SL','SLE',694),
  (199,'Singapore','SINGAPORE','SG','SGP',702),
  (200,'Sint Maarten','SINTMAARTEN','SX','SXM',534),
  (201,'Slovakia','SLOVAKIA','SK','SVK',703),
  (202,'Slovenia','SLOVENIA','SI','SVN',705),
  (203,'Solomon Islands','SOLOMONISLANDS','SB','SLB',90),
  (204,'Somalia','SOMALIA','SO','SOM',706),
  (205,'SouthAfrica','SOUTHAFRICA','ZA','ZAF',710),
  (206,'South Georgia andt he South Sandwich Islands','SOUTHGEORGIAANDTHESOUTHSANDWICHISLANDS','GS','SGS',239),
  (207,'SouthKorea','SOUTHKOREA','KR','KOR',410),
  (208,'South Sudan','SOUTHSUDAN','SS','SSD',728),
  (209,'Spain','SPAIN','ES','ESP',724),
  (210,'Sri Lanka','SRILANKA','LK','LKA',144),
  (211,'Sudan','SUDAN','SD','SDN',736),
  (212,'Suriname','SURINAME','SR','SUR',740),
  (213,'Svalbard and Jan Mayen','SVALBARDANDJANMAYEN','SJ','SJM',744),
  (214,'Swaziland','SWAZILAND','SZ','SWZ',748),
  (215,'Sweden','SWEDEN','SE','SWE',752),
  (216,'Switzerland','SWITZERLAND','CH','CHE',756),
  (217,'Syrian Arab Republic','SYRIANARABREPUBLIC','SY','SYR',760),
  (218,'Taiwan Province of China','TAIWANPROVINCEOFCHINA','TW','TWN',158),
  (219,'Tajikistan','TAJIKISTAN','TJ','TJK',762),
  (220,'Tanzania United Republic','TANZANIAUNITEDREPUBLIC','TZ','TZA',834),
  (221,'Thailand','THAILAND','TH','THA',764),
  (222,'Timor-Leste','TIMOR-LESTE','TL','TLS',626),
  (223,'Togo','TOGO','TG','TGO',768),
  (224,'Tokelau','TOKELAU','TK','TKL',772),
  (225,'Tonga','TONGA','TO','TON',776),
  (226,'Trinidad and Tobago','TRINIDADANDTOBAGO','TT','TTO',780),
  (227,'Tunisia','TUNISIA','TN','TUN',788),
  (228,'Turkey','TURKEY','TR','TUR',792),
  (229,'Turkmenistan','TURKMENISTAN','TM','TKM',795),
  (230,'Turks and Caicos Islands','TURKSANDCAICOSISLANDS','TC','TCA',796),
  (231,'Tuvalu','TUVALU','TV','TUV',798),
  (232,'Uganda','UGANDA','UG','UGA',800),
  (233,'Ukraine','UKRAINE','UA','UKR',804),
  (234,'United Arab Emirates','UNITEDARABEMIRATES','AE','ARE',784),
  (235,'United Kingdom','UNITEDKINGDOM','GB','GBR',826),
  (236,'United States','UNITEDSTATES','US','USA',840),
  (237,'United States Minor Outlying Islands','UNITEDSTATESMINOROUTLYINGISLANDS','UM','UMI',581),
  (238,'Uruguay','URUGUAY','UY','URY',858),
  (239,'Uzbekistan','UZBEKISTAN','UZ','UZB',860),
  (240,'Vanuatu','VANUATU','VU','VUT',548),
  (241,'Venezuela','VENEZUELA','VE','VEN',862),
  (242,'VietNam','VIETNAM','VN','VNM',704),
  (243,'Virgin Islands British','VIRGINISLANDSBRITISH','VG','VGB',92),
  (244,'Virgin Islands US','VIRGINISLANDSUS','VI','VIR',850),
  (245,'Wallis and Futuna','WALLISANDFUTUNA','WF','WLF',876),
  (246,'Western Sahara','WESTERNSAHARA','EH','ESH',732),
  (247,'Yemen','YEMEN','YE','YEM',887),
  (248,'Zambia','ZAMBIA','ZM','ZMB',894),
  (249,'Zimbabwe','ZIMBABWE','ZW','ZWE',716),
  (999,NULL,NULL,NULL,NULL,NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description, description_capitalized = EXCLUDED.description_capitalized, iso_alpha2 = EXCLUDED.iso_alpha2, iso_alpha3 = EXCLUDED.iso_alpha3, iso_numeric = EXCLUDED.iso_numeric;


INSERT INTO public."ref-lineage" VALUES
  (1, 'B-lineage'),
  (2, 'T-lineage'),
  (3, 'Myeloid lineage'),
  (9, 'other')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-diagnosis" VALUES
  (1, 'BCP-ALL', 1),
  (3, 'T-LBL', 2),
  (5, 'MPAL (B/myeloid)', NULL),
  (6, 'MPAL (T/myeloid)', NULL),
  (7, 'MPAL (B/T)', NULL),
  (8, 'MPAL (B/T/myeloid)', NULL),
  (2, 'T-ALL', 2),
  (4, 'AML', 3),
  (9, 'MDS', 3),
  (10, 'Hairy cell leukemia', 9),
  (11, 'Burkitt lymphoma', 9),
  (12, 'AUL', NULL),
  (13, 'Acute NK-cell leukemia (ANKL)', 9),
  (14, 'DLBCL', 9),
  (15, 'Mantel cell lymphoma', 9),
  (16, 'CML', 3),
  (17, 'High grade glioma', 9),
  (18, 'Low grade glioma', 9),
  (19, 'Glioblastoma', 9),
  (20, 'Ependymoma', 9),
  (21, 'Medulloblastoma', 9),
  (22, 'AT/RT', 9),
  (23, 'Craniopharyngeoma', 9),
  (24, 'DMG/DIPG', 9),
  (25, 'Germ cell tumor', 9),
  (26, 'Neuroblastoma', 9),
  (27, 'Osteosarcoma', 9),
  (28, 'Rhabdomyosarcoma', 9),
  (29, 'Rhabdoid Tumor', 9),
  (30, 'Ewing sarcoma', 9),
  (31, 'Soft tissue sarcoma', 9),
  (32, 'B-LBL', 1),
  (33, 'Synovial sarcoma', 9),
  (99, 'Other', NULL),
  (999, NULL, 9)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description, lineage_id = EXCLUDED.lineage_id;


INSERT INTO public."ref-disease_stage" VALUES
  (0, 'Initial diagnosis'),
  (1, '1st relapse'),
  (2, '2nd relapse'),
  (3, '3rd relapse'),
  (4, '4th relapse'),
  (5, '5th relapse'),
  (6, '6th relapse'),
  (7, '7th relapse'),
  (8, '8th relapse'),
  (98, 'Death'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-egil_fab" VALUES
  (99, NULL, NULL),
  (12, 'Common B', 1),
  (11, 'Pro-B', 1),
  (13, 'Pre-B', 1),
  (14, 'Mature B', 1),
  (21, 'Pro-T', 2),
  (22, 'Pre-T', 2),
  (23, 'Cortical T', 2),
  (24, 'Mature T', 2),
  (40, 'M0', 3),
  (41, 'M1', 3),
  (42, 'M2', 3),
  (43, 'M3', 3),
  (44, 'M4', 3),
  (45, 'M5', 3),
  (46, 'M6', 3),
  (47, 'M7', 3)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description, lineage_id = EXCLUDED.lineage_id;


INSERT INTO public."ref-ethnicity" VALUES
  (1, 'Asian'),
  (2, 'Black'),
  (3, 'White'),
  (4, 'Hispanic'),
  (5, 'Native American/Alaskan'),
  (6, 'Hawaiian/Pacific Islander'),
  (7, 'Multi-ethnic'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-expression" VALUES
  (0, 'negative'),
  (1, 'weak'),
  (2, 'strong')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-functional_class" VALUES
  (1, 'AKT inhibitor'),
  (2, 'Alkylating agent'),
  (3, 'Anthelmintic'),
  (4, 'Antimetabolite'),
  (5, 'Antimicrotubule agent'),
  (6, 'Anthracycline'),
  (7, 'Aurora kinase inhibitor'),
  (8, 'BCL2 inhibitor'),
  (9, 'BRD inhibitor'),
  (10, 'CDK inhibitor'),
  (11, 'CHK inhibitor'),
  (12, 'BET inhibitor'),
  (13, 'FGFR inhibitor'),
  (14, 'Glucocorticoid'),
  (15, 'HAT inhibitor'),
  (16, 'pan-HDAC inhibitor'),
  (17, 'HSP inhibitor'),
  (18, 'IAP inhibitor'),
  (19, 'IGFR inhibitor'),
  (20, 'BCLXL inhibitor'),
  (21, 'Antibiotic'),
  (22, 'MCL1 inhibitor'),
  (23, 'MDM2 inhibitor'),
  (24, 'MEK inhibitor'),
  (25, 'Monoclonal antibody'),
  (26, 'mTOR inhibitor'),
  (27, 'Exportin inhibitor'),
  (28, 'Survivin inhibitor'),
  (29, 'EP300/CBP inhibitor'),
  (30, 'P53 activator'),
  (31, 'PARP inhibitor'),
  (32, 'PDK1 inhibitor'),
  (33, 'CK2 inhibitor'),
  (34, 'Proteasome inhibitor'),
  (35, 'Protein synthesis inhibitor'),
  (36, 'RAF inhibitor'),
  (37, 'RAS inhibitor'),
  (38, 'RIPK1 inhibitor'),
  (39, 'Secretase inhibitor'),
  (40, 'Topoisomerase inhibitor'),
  (41, 'Transcription factor inhibitor'),
  (42, 'Tyrosine kinase inhibitor'),
  (43, 'JAK1 inhibitor'),
  (44, 'ABL inhibitor'),
  (45, 'LCK inhibitor'),
  (46, 'SRC inhibitor'),
  (47, 'BTK inhibitor'),
  (48, 'ALK inhibitor'),
  (49, 'VEGFR inhibitor'),
  (50, 'EGFR inhibitor'),
  (51, 'PDGFR inhibitor'),
  (52, 'KIT inhibitor'),
  (53, 'FLT3 inhibitor'),
  (54, 'MET inhibitor'),
  (55, 'HDAC inhibitor'),
  (56, 'SYK inhibitor'),
  (57, 'AXL inhibitor'),
  (58, 'Purine analog'),
  (59, 'Pyrimidine analog'),
  (60, 'SIRT1 inhibitor'),
  (61, 'PLK1 inhibitor'),
  (62, 'WEE1 inhibitor'),
  (63, 'ITK inhibitor'),
  (64, 'EPH inhibitor'),
  (65, 'JAK2 inhibitor'),
  (66, 'JAK3 inhibitor'),
  (67, 'DNA crosslinker'),
  (68, 'IDH1 inhibitor'),
  (69, 'IDH2 inhibitor'),
  (70, 'Statin'),
  (71, 'ROS1 inhibitor'),
  (72, 'TRK inhibitor'),
  (73, 'SMO inhibitor'),
  (74, 'NEDD8 inhibitor'),
  (75, 'RET inhibitor'),
  (76, 'HMT inhibitor'),
  (77, 'ERK inhibitor'),
  (78, 'ROS inducer'),
  (79, 'ATM inhibitor'),
  (80, 'ATR inhibitor'),
  (81, 'GSK3 inhibitor'),
  (82, 'PKC inhibitor'),
  (83, 'PKA inhibitor'),
  (84, 'P38 inhibitor'),
  (85, 'HER2 inhibitor'),
  (86, 'FAK inhibitor'),
  (87, 'PIM inhibitor'),
  (88, 'ROCK inhibitor'),
  (89, 'Jumonji inhibitor'),
  (90, 'PAK inhibitor'),
  (91, 'NOTCH inhibitor'),
  (92, 'PPAR inhibitor'),
  (93, 'IkB/IKK inhibitor'),
  (94, 'CSF1R inhibitor'),
  (95, 'COX2 inhibitor'),
  (96, 'RNR inhibitor'),
  (97, 'NUAK inhibitor'),
  (98, 'Cereblon E3 ligase modulator'),
  (99, 'BCL6 inhibitor'),
  (100, 'Menin inhibitor'),
  (101, 'STAT3 inhibitor'),
  (102, 'DMARD inhibitor'),
  (103, 'HDM inhibitor'),
  (104, 'RNA POL3 inhibitor'),
  (105, 'CDK1 inhibitor'),
  (106, 'CDK2 inhibitor'),
  (107, 'CDK3 inhibitor'),
  (108, 'CDK4 inhibitor'),
  (109, 'CDK5 inhibitor'),
  (110, 'CDK6 inhibitor'),
  (111, 'CDK7 inhibitor'),
  (112, 'CDK8 inhibitor'),
  (113, 'CDK9 inhibitor'),
  (114, 'CDK10 inhibitor'),
  (115, 'CDK11 inhibitor'),
  (116, 'CDK12 inhibitor'),
  (117, 'CDK13 inhibitor'),
  (118, 'HDAC1 inhibitor'),
  (119, 'HDAC2 inhibitor'),
  (120, 'HDAC3 inhibitor'),
  (121, 'HDAC4 inhibitor'),
  (122, 'HDAC5 inhibitor'),
  (123, 'HDAC6 inhibitor'),
  (124, 'HDAC7 inhibitor'),
  (125, 'HDAC8 inhibitor'),
  (126, 'HDAC9 inhibitor'),
  (127, 'HDAC10 inhibitor'),
  (128, 'HDAC11 inhibitor'),
  (129, 'PI3K inhibitor'),
  (130, 'OXPHOS inhibitor'),
  (131, 'Enzyme'),
  (132, 'CXCR4 inhibitor'),
  (133, 'Immunotherapy'),
  (134, 'RNA POL1 inhibitor'),
  (135, 'ODC inhibitor'),
  (136, 'Adenosine analog'),
  (137, 'Guanoside analog'),
  (138, 'Cytidine analog'),
  (139, 'Uridine analog'),
  (140, 'Kinesin inhibitor'),
  (141, 'EZH2 degrader'),
  (142, 'MAT2A inhibitor'),
  (143, 'SHMT inhibitor'),
  (144, 'SIK inhibitor'),
  (145, 'LYN inhibitor'),
  (146, 'DYRK inhibitor'),
  (147, 'SMARCA5 inhibitor'),
  (148, 'SAMDC inhibitor'),
  (149, 'CETP inhibitor'),
  (150, 'ACC inhibitor'),
  (151, 'FASN inhibitor'),
  (152, 'tri-snRNP inhibitor'),
  (153, 'MMP9 inhibitor'),
  (154, 'RBM39/23 degrader'),
  (155, 'CLK1 inhibitor'),
  (156, 'CLK2 inhibitor'),
  (157, 'CLK3 inhibitor'),
  (158, 'CLK4 inhibitor'),
  (159, 'SRPK1 inhibitor'),
  (160, 'SRPK2 inhibitor'),
  (161, 'SRPK3 inhibitor'),
  (162, 'PRMT1 inhibitor'),
  (163, 'PRMT2 inhibitor'),
  (164, 'PRMT3 inhibitor'),
  (165, 'PRMT5 inhibitor'),
  (166, 'PRMT6 inhibitor'),
  (167, 'PRMT7 inhibitor'),
  (168, 'PRMT8 inhibitor'),
  (169, 'PRMT9 inhibitor'),
  (170, 'SF3B1 inhibitor'),
  (171, 'SF3B1 PROTAC'),
  (172, 'SF3B1-U2AF2 interaction inhibitor'),
  (173, 'MAP4K4 inhibitor'),
  (174, 'PRMT4 inhibitor'),
  (175, 'DHODH inhibitor'),
  (176, 'PTEN inhibitor'),
  (177, 'AKT activator'),
  (178, 'SHIP1 inhibitor'),
  (179, 'TRAIL agonist'),
  (180, 'MLKL inhibitor'),
  (181, 'Biphosphonate'),
  (182, 'Benzodiazepin'),
  (183, 'JNK inhibitor'),
  (184, 'SGK inhibitor'),
  (185, 'Telomerase inhibitor'),
  (186, 'Aminopeptidase inhibitor'),
  (187, 'PDE4 inhibitor'),
  (999, 'Other')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-hospital" VALUES
  (1, 'University Children''s Hospital Zurich'),
  (2, 'Charité Universitätsmedizin Berlin'),
  (3, 'Universitätsklinikum Schleswig-Holstein'),
  (4, 'CHUV Lausanne'),
  (5, 'Rigshospitalet Copenhagen'),
  (6, 'University Hospital Basel'),
  (7, 'St. Anna Children''s Hospital'),
  (8, 'HUG Geneva'),
  (9, 'Tettamanti Research Center Monza'),
  (10, 'Princess Maxima Center'),
  (11, 'Great Ormond Street Hospital'),
  (12, 'University Hospital Zurich'),
  (13, 'Universitätsklinikum Düsseldorf'),
  (14, 'Aarhus University Hospital'),
  (15, 'UniPG Perugia'),
  (16, 'CHU Nice'),
  (17, 'Universitätsklinikum Münster'),
  (18, 'Schneider Children''s Medical Center'),
  (19, 'Inselspital Bern'),
  (20, 'MH Hannover'),
  (21, 'Ospedale Pediatrico Bambino Gesu'),
  (22, 'APHP Paris'),
  (23, 'Karolinska Institute'),
  (24, 'Motol University Hospital'),
  (25, 'Sheba Medical Center'),
  (26, 'Universitätsklinikum Erlangen'),
  (27, 'CHU Bordeaux'),
  (28, 'Universitätsklinikum Greifswald'),
  (29, 'Universitätsklinikum Würzburg'),
  (30, 'Lucile Packard Children''s Hospital'),
  (31, 'CHU Rouen'),
  (32, 'Universitätsklinikum Heidelberg'),
  (33, 'Hôpital Universitaire des Enfants Reine Fabiola'),
  (34, 'Ghent University Hospital'),
  (35, 'Medipol Mega University Hospital Istanbul'),
  (36, 'University Hospital Padova'),
  (37, 'CHU Lille'),
  (38, 'Universitätsklinikum Magdeburg'),
  (39, 'Maria Pia Hospital Torino'),
  (40, 'ASST Papa Giovanni XXIII Bergamo'),
  (41, 'Ente Ospedaliero Cantonale Bellinzona'),
  (42, 'Vall d''Hebron University Hospital'),
  (43, 'IPO Lisboa'),
  (44, 'Children''s Clinical University Hospital Riga'),
  (45, 'CHU Toulouse'),
  (46, 'Universitätsklinikum Innsbruck'),
  (47, 'CHU Nancy'),
  (48, 'CHU Strasbourg'),
  (49, 'CHU Poitier'),
  (50, 'Universitätsklinikum Frankfurt'),
  (51, 'University Hospital Umeå'),
  (52, 'OHSU Oregon'),
  (53, 'Universitätsklinikum Oldenburg'),
  (54, 'UZ Leuven'),
  (55, 'Universitätsklinikum Freiburg'),
  (56, 'Universitäts-Kinderspital beider Basel'),
  (57, 'BAU Medical Park Göztepe Hospital'),
  (58, 'Kantonsspital Aarau'),
  (59, 'Universitätsklinikum Essen'),
  (60, 'Ostschweizer Kinderspital St. Gallen'),
  (61, 'Wroclaw Medical University'),
  (62, 'Semmelweis University Hospital'),
  (63, 'Bursa Uludag University Hospital'),
  (64, 'Ege University Hospital Izmir'),
  (65, 'Marmara University Hospital Pendik'),
  (66, 'Seattle Children''s Hospital'),
  (67, 'Oslo University Hospital'),
  (68, 'CHU Dijon Bourgogne'),
  (69, 'Antwerp University Hospital'),
  (70, 'Medical University of Pécs'),
  (71, 'Kantonsspital Luzern'),
  (72, 'Odense University Hospital'),
  (73, 'CHU de Reims'),
  (74, 'Universitätsklinikum Ulm'),
  (75, 'Universitätsklinikum Jena'),
  (76, 'University Medical Centre Ljubljana'),
  (77, 'Vilnius University Hospital Santaros Klinikos'),
  (78, 'UMPCD Bucharest'),
  (79, 'Istanbul Yeni Yuzyil University Hospital'),
  (80, 'HUDERF Brussel'),
  (81, 'Universitätsklinikum Giessen'),
  (82, 'KDHO Bratislava'),
  (83, 'IRCCS Azienda Ospedaliero Universitaria di Bologna'),
  (84, 'Center Hospital of South-Pest Budapest (DPC)'),
  (85, 'Lösante Hospital Ankara'),
  (86, 'CHU Clermont Ferrand'),
  (87, 'Universitätsklinikum Mainz'),
  (88, 'Acibadem Altunizade Hospital'),
  (89, 'Balgrist University Hospital'),
  (90, 'Kantonsspital Winterthur'),
  (91, 'Kantonsspital St. Gallen'),
  (92, 'Regional Specialized Children''s Hospital Olsztyn'),
  (93, 'Children''s Hospital Kosice'),
  (94, 'University Hospital Bristol'),
  (95, 'Newcastle upon Tyne Hospitals'),
  (96, 'Rambam Health Care Campus'),
  (97, 'Royal Manchester Children''s Hospital'),
  (98, 'University Hospital No. 1 Bydgoszcz'),
  (99, 'Kantonsspital Graubünden'),
  (999, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-layout_type" VALUES
  (1, 'source plate'),
  (2, 'destination plate')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-marker_category" VALUES
  (1, 'Stem cell / progenitor marker'),
  (2, 'Myelo/monocytic marker'),
  (3, 'B-lymphatic marker'),
  (4, 'T-lymphatic marker'),
  (5, 'Megakaryocytic marker'),
  (6, 'Erythrocytic marker'),
  (7, 'LSC associated marker'),
  (8, 'Pan leukocytic marker')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-marker" VALUES
  (0, 'CyQuant',NULL),
  (1, 'CD34', 1),
  (2, 'HLA-DR', 1),
  (3, 'CD123', 1),
  (4, 'CD38', 1),
  (5, 'CyMPO', 2),
  (6, 'CD117', 2),
  (7, 'CD14', 2),
  (8, 'CD16', 2),
  (9, 'CD64', 2),
  (10, 'CD11b',2),
  (11, 'CD13', 2),
  (12, 'CD15', 2),
  (13, 'CD33', 2),
  (14, 'cyCD79a', 3),
  (15, 'CD19', 3),
  (16, 'CD10', 3),
  (17, 'CD22', 3),
  (18, 'cyCD22', 3),
  (19, 'cyCD3', 4),
  (20, 'CD4', 4),
  (21, 'CD7', 4),
  (22, 'CD56', 4),
  (23, 'CD41', 5),
  (24, 'CD61', 5),
  (25, 'CD42b', 5),
  (26, 'CD36', 6),
  (27, 'CD71', 6),
  (28, 'CD105', 6),
  (29, 'CLL-1', 7),
  (30, 'TIM-3', 7),
  (31, 'CD9', 7),
  (32, 'CD45RA', 7),
  (33, 'CD47', 7),
  (34, 'CD96', 7),
  (35, 'CD97', 7),
  (36, 'CD99', 7),
  (37, 'CD11c', 2),
  (38, 'CD11a', 8),
  (39, 'CD45', 8),
  (40, 'CD20', 3),
  (41, 'CD58', 8),
  (42,'CD3', 4),
  (43,'CellTiter Glo 2.0', NULL),
  (44,'CellTiter Glo 3D', NULL),
  (45,'Resazurin', NULL),
  (-1000, '-CyQuant', NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description, category_id = EXCLUDED.category_id;


INSERT INTO public."ref-medium" VALUES
  (1, 'AIM-V'),
  (2, 'Plasmax'),
  (3, 'RPMI'),
  (4, 'MEM-alpha'),
  (5, 'human plasma'),
  (6, 'DMEM'),
  (7, 'IMDM'),
  (8, 'Adv.DMEM/F12'),
  (9, 'TSM'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-origin" VALUES
  (0, 'Primary'),
  (1, 'PDX1'),
  (2, 'PDX2'),
  (3, 'PDX3'),
  (4, 'PDX4'),
  (5, 'PDX5'),
  (6, 'Cell line'),
  (7, 'Organoid'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-plate_format" VALUES
  (1, '96-well'),
  (2, '384-well'),
  (3, '1536-well')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-readout" VALUES
  (1, 'Viable leukemia cells'),
  (2, 'MSC'),
  (3, 'Dead cells'),
  (4, 'Viable non-leukemia cells'),
  (5, 'Viable MNC')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-response_assessment" VALUES
  (1, 'PD', 'Progressive disease'),
  (2, 'SD', 'Stable disease'),
  (3, 'PR', 'Partial response'),
  (4, 'CRi', 'Complete remission with incomplete hematological recovery'),
  (5, 'CRp', 'Complete remission without platelet recovery'),
  (6, 'CR', 'Complete remission'),
  (7, 'Death', 'Death'),
  (9, 'LFU', 'Lost to follow-up'),
  (10, 'PPR (≥ 1000 blasts/uL)', 'Prednisone poor response'),
  (11, 'PGR (< 1000 blasts/uL)', 'Prednisone good response'),
  (12, 'Alive at last FU', 'Alive at last follow-up'),
  (99, NULL, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description, description_long = EXCLUDED.description_long;


INSERT INTO public."ref-response_method" VALUES
  (1, 'Morphology'),
  (2, 'PCR-MRD'),
  (3, 'Flow-MRD'),
  (4, 'Histology'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-response_mrd" VALUES
  (0, 'Negative'),
  (1, 'Positive non-quantifiable'),
  (2, 'Positive'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-sex" VALUES
  (1, 'Male', 'C20197'),
  (2, 'Female', 'C16576'),
  (9, NULL, 'C17998')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description, ncit = EXCLUDED.ncit;


INSERT INTO public."ref-subtype" VALUES
  (1, 'High hyperdiploidy', 1),
  (2, 'iAMP21', 1),
  (3, 'Near haploidy', 1),
  (4, 'Low hypodiploidy', 1),
  (5, 'ETV6::RUNX1', 1),
  (6, 'TCF3::PBX1', 1),
  (7, 'TCF3::HLF', 1),
  (8, 'DUX4', 1),
  (9, 'KMT2Ar', NULL),
  (10, 'ETV6::RUNX1-like', 1),
  (11, 'MEF2Dr', 1),
  (12, 'ZNF384r', 1),
  (13, 'NUTM1r', 1),
  (14, 'KMT2A-like', 1),
  (15, 'ZNF384-like', 1),
  (16, 'PAX5alt', 1),
  (17, 'PAX5 P80R', 1),
  (18, 'IKZF1 plus', 1),
  (19, 'ZEB2/CEBP', 1),
  (20, 'BCL2/MYC', 1),
  (21, 'BCR::ABL1', 1),
  (22, 'Ph-like', 1),
  (23, 'Other', 1),
  (24, 'TAL1', 2),
  (25, 'HOXA', 2),
  (26, 'TLX3', 2),
  (27, 'TLX1', 2),
  (28, 'NKX2-1', 2),
  (29, 'LMO1/2', 2),
  (30, 'BCL11B', 2),
  (31, 'TAL2', 2),
  (32, 'SPI1', 2),
  (33, 'IKZFalt', 1),
  (34, 'NUP214::ABL1', 2),
  (35, 'Ph-like CRLF2', 1),
  (36, 'RUNX1::RUNX1T1', 3),
  (37, 'CBFB::MYH11', 3),
  (38, 'PML::RARA', 3),
  (39, 'NUP98r', 3),
  (40, 'ETV6r', 3),
  (41, 'DEK::NUP214', 3),
  (42, 'MECOMr', 3),
  (43, 'CBFA2T3::GLIS2', 3),
  (44, 'FUS::ERG', 3),
  (45, 'RBM15::MKL1', 3),
  (46, 'NPM1', 3),
  (47, 'PICALM::MLLT10', NULL),
  (48, 'UBTF-TD', 2),
  (49, 'Monosomy 7', 2),
  (50, 'PAX3::FOXO', NULL),
  (51, 'PAX7::FOXO', NULL),
  (99, NULL, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description, lineage_id = EXCLUDED.lineage_id;


INSERT INTO public."ref-relapse_time" VALUES
  (1, 'very early (<18mo after dx)'),
  (2, 'early (>=18mo after dx and <6mo after therapy completion)'),
  (3, 'late (>6mo after therapy completion)'),
  (4, 'not very early (>=18mo after dx)'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-tissue" VALUES
  (1, 'Bone marrow'),
  (2, 'Peripheral blood'),
  (3, 'Pleural effusion'),
  (4, 'Cerebrospinal fluid'),
  (5, 'Spleen'),
  (6, 'Liver'),
  (7, 'Kidney'),
  (8, 'Brain'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-unit" VALUES
  (1, 'mM'),
  (2, 'uM'),
  (3, 'nM'),
  (4, 'U/L'),
  (5, '%'),
  (6, 'ng/mL'),
  (7, 'mg/m^2'),
  (8, 'IU/m^2'),
  (9, 'mg/kg')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-fitmodel" VALUES
  (1, 'LL.2'),
  (2, 'LL.3'),
  (3, 'LL.4'),
  (4, 'LL.5')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-msc_detachment" VALUES
  (1, 'None'),
  (2, 'Mild (locally detached)'),
  (3, 'Strong (globally detached / peeled)'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-localization" VALUES
  (1, 'BM isolated'),
  (2, 'BM combined'),
  (3, 'Extramedullary w/o BM'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-cns_status" VALUES
  (1, 'CNS 1 (no blasts)'),
  (2, 'CNS 2 (<5/uL WBC with blasts)'),
  (3, 'CNS 3 (≥5/uL WBC with blasts)'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-reader_function" VALUES
  (1, 'read_layout_d300', 'layout'),
  (2, 'read_generic_measurement', 'measurement'),
  (3, 'read_transposed_measurement', 'measurement')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description, type = EXCLUDED.type;


INSERT INTO public."ref-contamination" VALUES
  (0, 'None'),
  (1, 'Mild (few scattered wells)'),
  (2, 'Strong (>50% of plate or mycoplasma)'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-resolution" VALUES
  (1, '10x'),
  (2, '20x'),
  (3, '40x'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-organ" VALUES
  (1, 'Bone marrow'),
  (2, 'Spleen'),
  (3, 'Liver'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-death_cause" VALUES
  (1, 'Disease'),
  (2, 'Toxicity'),
  (3, 'GvHD'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-risk" VALUES
  (1, 'SR'),
  (2, 'MR'),
  (3, 'HR'),
  (4, 'VHR'),
  (9, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-gene_signature" VALUES
  (1, 'IKZF1plus'),
  (2, 'KMT2A-like'),
  (3, 'Ph-like'),
  (4, 'EVT6::RUNX1-like'),
  (5, 'ZNF384-like'),
  (6, 'ETP-like'),
  (7, 'TME-enriched'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-solvent" VALUES
  (1, 'DMSO'),
  (2, 'H2O')
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-collection_method" VALUES
  (1, 'BM aspiration'),
  (2, 'Biopsy'),
  (3, 'Tumor resection'),
  (4, 'Lumbar puncture'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-coating" VALUES
  (1, 'Matrigel'),
  (2, 'Fibronectin'),
  (3, 'Gelatin'),
  (4, 'Collagen'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-modality" VALUES
  (1, 'image-based'),
  (2, 'metabolic'),
  (99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;


INSERT INTO public."ref-chromosomal_aberration" VALUES
(1, 'Hyperdiploidy'),
(2, 'Hypodiploidy'),
(3, 'Near haploidy'),
(4, 'iAMP21'),
(5, 'Monosomy 7'),
(99, NULL)
ON CONFLICT (id) DO UPDATE
SET description = EXCLUDED.description;