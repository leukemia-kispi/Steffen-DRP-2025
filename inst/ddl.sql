CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;

--- Reference tables -----------------------------------------------------------

CREATE TABLE "ref-alteration" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-anticoagulant" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-approval_status" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-biological_process" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-block" (
    block_id integer NOT NULL,
    block character varying,
    protocol_id integer
);

CREATE TABLE "ref-block__drug" (
    block_id integer NOT NULL,
    drug_id integer NOT NULL
);

CREATE TABLE "ref-cell_isolation" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-chromosomal_aberration" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-cns_status" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-coating" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-collection_method" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-contamination" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-country" (
    iso_alpha2 character varying,
    iso_alpha3 character varying,
    iso_numeric integer,
    description_capitalized character varying,
    description character varying,
    id integer NOT NULL
);

CREATE TABLE "ref-death_cause" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-diagnosis" (
    id integer NOT NULL,
    description character varying,
    lineage_id integer
);

CREATE TABLE "ref-disease_stage" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-echo_plate" (
    id integer NOT NULL,
    class character varying NOT NULL,
    solvent character varying NOT NULL,
    name character varying,
    volume integer,
    type character varying
);

CREATE TABLE "ref-egil_fab" (
    id integer NOT NULL,
    description character varying,
    lineage_id integer
);

CREATE TABLE "ref-ethnicity" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-expression" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-fitmodel" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-functional_class" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-functional_consequence" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-gene" (
    id integer NOT NULL,
    description character varying,
    hgnc_id character varying,
    description_long character varying
);

CREATE TABLE "ref-gene_signature" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-hospital" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-layout_type" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-lineage" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-localization" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-marker" (
    id integer NOT NULL,
    description character varying,
    category_id integer
);

CREATE TABLE "ref-marker_category" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-medium" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-modality" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-msc_detachment" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-ordered_feature" (
    feature character varying NOT NULL,
    is_ordered boolean
);

CREATE TABLE "ref-organ" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-origin" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-plate_format" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-protocol" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-reader_function" (
    id integer NOT NULL,
    description character varying,
    type character varying
);

CREATE TABLE "ref-readout" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-relapse_time" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-resolution" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-response_assessment" (
    id integer NOT NULL,
    description character varying,
    description_long character varying
);

CREATE TABLE "ref-response_method" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-response_mrd" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-risk" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-sex" (
    id integer NOT NULL,
    description character varying,
    ncit character varying
);

CREATE TABLE "ref-solvent" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-subtype" (
    id integer NOT NULL,
    description character varying,
    lineage_id integer
);

CREATE TABLE "ref-target" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-tissue" (
    id integer NOT NULL,
    description character varying
);

CREATE TABLE "ref-unit" (
    id integer NOT NULL,
    description character varying
);


-- Tables ----------------------------------------------------------------------

CREATE TABLE assay (
    assay_id integer NOT NULL,
    sid integer,
    cancer_thawing real,
    drp_date date,
    msc_passage integer,
    cancer_seeded integer,
    msc_seeded integer,
    drp_hospital_id integer,
    assay_description character varying,
    msc_detached_id integer,
    contaminated_id integer,
    origin_id integer,
    exclude_assay boolean,
    cancer_18h integer,
    assay_failed boolean,
    comment character varying,
    tenant_id character varying,
    user_id character varying,
    drug_exposure_hours integer,
    medium_id integer,
    fraction_msc_detached real,
    fresh boolean,
    coverage_18h real,
    marker_based boolean,
    is_combination boolean,
    assay_reported boolean,
    medium_supplement character varying,
    coating_id integer,
    cancer_passage integer
);


CREATE TABLE sample (
    sid integer NOT NULL,
    pid integer NOT NULL,
    lknumber character varying,
    city character varying,
    disease_stage_id integer,
    egil_id integer,
    etp boolean,
    diagnosis_id integer,
    comment character varying,
    cancer_fraction real,
    tissue_id integer,
    cell_isolation_id integer,
    anticoagulant_id integer,
    question character varying,
    sending_hospital_id integer,
    correspondence character varying,
    sending_date date,
    mio_cells_shipped real,
    fresh boolean,
    puncture_date date,
    clinical_trial character varying,
    inform character varying,
    day0 boolean,
    timepoint_collection character varying,
    country_id integer,
    shipping_medium character varying,
    sample_crossref character varying,
    exclude_sample boolean,
    tenant_id character varying,
    user_id character varying,
    sent_for_pdx boolean,
    arrival_date date,
    reporting_date date,
    collection_method_id integer
);


CREATE VIEW assay_view AS
 SELECT a.assay_id,
    a.assay_description,
    a.sid,
    s.lknumber,
    a.origin_id,
    o.description AS origin,
    a.drp_hospital_id,
    h.description AS drp_hospital,
    a.drp_date,
    a.msc_passage,
    a.msc_seeded,
    a.fraction_msc_detached,
    a.msc_detached_id,
    m.description AS msc_detached,
    a.fresh,
    a.cancer_thawing,
    a.cancer_passage,
    a.cancer_seeded,
    a.cancer_18h,
    a.coverage_18h,
    a.drug_exposure_hours,
    a.marker_based,
    a.medium_id,
    mm.description AS medium,
    a.medium_supplement,
    a.coating_id,
    co.description AS coating,
    a.contaminated_id,
    c.description AS contaminated,
    a.assay_failed,
    a.exclude_assay,
    a.is_combination,
    a.assay_reported
   FROM (((((((assay a
     LEFT JOIN "ref-hospital" h ON ((a.drp_hospital_id = h.id)))
     LEFT JOIN "ref-msc_detachment" m ON ((a.msc_detached_id = m.id)))
     LEFT JOIN "ref-contamination" c ON ((a.contaminated_id = c.id)))
     LEFT JOIN "ref-medium" mm ON ((a.medium_id = mm.id)))
     LEFT JOIN "ref-coating" co ON ((a.coating_id = co.id)))
     LEFT JOIN sample s ON ((a.sid = s.sid)))
     LEFT JOIN "ref-origin" o ON ((a.origin_id = o.id)));


CREATE TABLE drug__biological_process (
    drug_id integer NOT NULL,
    biological_process_id integer NOT NULL,
    user_id character varying,
    tenant_id character varying
);


CREATE VIEW biological_process_view AS
 SELECT dbp.drug_id,
    dbp.biological_process_id,
    fc.description AS biological_process
   FROM (drug__biological_process dbp
     LEFT JOIN "ref-biological_process" fc ON ((dbp.biological_process_id = fc.id)));


CREATE TABLE block__drug_sele (
    block_id integer NOT NULL,
    drug_id integer NOT NULL,
    therapy_id integer NOT NULL
);


CREATE TABLE cohort (
    cohort_id integer NOT NULL,
    cohort_name character varying,
    tenant_id character varying,
    user_id character varying,
    cohort_description character varying
);


CREATE TABLE cohort__assay_sample (
    cohort_id integer NOT NULL,
    assay_id integer NOT NULL,
    tenant_id character varying,
    user_id character varying,
    sid integer NOT NULL
);


CREATE VIEW sample_view AS
 SELECT s.sid,
    s.pid,
    s.lknumber,
    "substring"((s.lknumber)::text, 3, 4) AS lkyear,
    s.sample_crossref,
    s.inform,
    s.clinical_trial,
    s.country_id,
    c.description AS country,
    s.city,
    s.disease_stage_id,
    ds.description AS disease_stage,
    s.puncture_date,
    s.timepoint_collection,
    s.cancer_fraction,
    s.tissue_id,
    t.description AS tissue,
    s.collection_method_id,
    cm.description AS collection_method,
    s.fresh,
    s.mio_cells_shipped,
    s.cell_isolation_id,
    ci.description AS cell_isolation,
    s.anticoagulant_id,
    a.description AS anticoagulant,
    s.shipping_medium,
    s.sending_hospital_id,
    h.description AS sending_hospital,
    s.correspondence,
    s.sending_date,
    s.arrival_date,
    s.reporting_date,
    s.exclude_sample,
    s.sent_for_pdx
   FROM (((((((sample s
     LEFT JOIN "ref-country" c ON ((s.country_id = c.id)))
     LEFT JOIN "ref-disease_stage" ds ON ((s.disease_stage_id = ds.id)))
     LEFT JOIN "ref-tissue" t ON ((s.tissue_id = t.id)))
     LEFT JOIN "ref-collection_method" cm ON ((s.collection_method_id = cm.id)))
     LEFT JOIN "ref-cell_isolation" ci ON ((s.cell_isolation_id = ci.id)))
     LEFT JOIN "ref-anticoagulant" a ON ((s.anticoagulant_id = a.id)))
     LEFT JOIN "ref-hospital" h ON ((s.sending_hospital_id = h.id)));


CREATE VIEW cohort__assay_sample_view AS
 SELECT cas.cohort_id,
    c.cohort_name,
    cas.assay_id,
    av.assay_description,
    cas.sid,
    sv.lknumber
   FROM (((cohort__assay_sample cas
     LEFT JOIN cohort c ON ((cas.cohort_id = c.cohort_id)))
     LEFT JOIN sample_view sv ON ((cas.sid = sv.sid)))
     LEFT JOIN assay_view av ON ((cas.assay_id = av.assay_id)));


CREATE TABLE drug (
    drug_id integer NOT NULL,
    kispi_id character varying NOT NULL,
    min_assay_conc real,
    max_assay_conc real,
    chembl character varying,
    abbreviation character varying,
    drug_name character varying,
    approval_status integer,
    unit_id integer,
    n_doses integer,
    stock_conc integer,
    priority integer,
    plate_priority integer,
    stock_well character varying,
    max_master_conc real,
    replicates integer,
    solvent_id integer,
    stock_plate_no bigint,
    cas_number character varying,
    user_id character varying,
    tenant_id character varying
);



CREATE TABLE layout_content (
    layout_id integer NOT NULL,
    "row" character varying NOT NULL,
    col integer NOT NULL,
    drug_id integer NOT NULL,
    concentration numeric NOT NULL,
    unit_id integer NOT NULL,
    material_id integer,
    medium_id integer,
    tenant_id character varying,
    user_id character varying,
    lot character varying,
    condition_index integer
);



CREATE TABLE material (
    material_id integer NOT NULL,
    sid integer NOT NULL,
    origin_id integer,
    mouse_id integer,
    derived_from_mouse_id integer,
    transplantation_id integer,
    cas9 boolean,
    tissue_id integer,
    tenant_id character varying,
    user_id character varying,
    has_engrafted boolean,
    transplantation_date date,
    harvesting_date date,
    comment character varying,
    empty boolean
);


CREATE VIEW material_view AS
 SELECT m.material_id,
    m.sid,
    s.lknumber,
    m.mouse_id,
    m.transplantation_id,
    m.derived_from_mouse_id,
    m.origin_id,
    mo.description AS origin,
    m.tissue_id,
    t.description AS tissue,
    m.cas9,
    m.transplantation_date,
    m.harvesting_date,
    m.has_engrafted,
    m.empty,
    m.comment
   FROM (((material m
     LEFT JOIN "ref-origin" mo ON ((m.origin_id = mo.id)))
     LEFT JOIN sample s ON ((m.sid = s.sid)))
     LEFT JOIN "ref-tissue" t ON ((m.tissue_id = t.id)));


CREATE VIEW layout_content_view AS
 SELECT lc.layout_id,
    lc."row",
    lc.col,
    lc.drug_id,
    d.drug_name,
    lc.concentration,
    lc.unit_id,
    u.description AS unit,
    mv.origin_id,
    o.description AS origin,
    lc.material_id,
    mv.mouse_id,
    mv.sid AS sid_material,
    mv.lknumber AS lknumber_material,
    lc.medium_id,
    mm.description AS medium,
    lc.condition_index,
    lc.lot
   FROM (((((layout_content lc
     LEFT JOIN material_view mv ON ((lc.material_id = mv.material_id)))
     LEFT JOIN "ref-unit" u ON ((lc.unit_id = u.id)))
     LEFT JOIN drug d ON ((lc.drug_id = d.drug_id)))
     LEFT JOIN "ref-origin" o ON ((mv.origin_id = o.id)))
     LEFT JOIN "ref-medium" mm ON ((lc.medium_id = mm.id)));



CREATE TABLE measurement (
    measurement_id integer NOT NULL,
    bias boolean,
    format_id integer,
    name character varying,
    resolution_id integer,
    img_well_coverage real,
    tenant_id character varying,
    user_id character varying,
    confocal boolean,
    plate_no integer,
    modality_id integer
);


CREATE TABLE patient (
    pid integer NOT NULL,
    patient_id integer,
    sex_id integer,
    diagnosis_id integer,
    egil_fab_id integer,
    etp boolean,
    consent boolean,
    subtype_id integer,
    treating_hospital_id integer,
    birth_year_month_date date,
    severe_concomitant_disease character varying,
    ethnicity_id integer,
    birth_year integer,
    has_lknumbers character varying,
    patient_crossref character varying,
    tenant_id character varying,
    user_id character varying,
    treating_physician character varying,
    in_fedrral boolean,
    consent_pdx boolean,
    consent_details character varying,
    comment character varying
);


CREATE VIEW patient_view AS
 SELECT p.pid,
    p.patient_crossref,
    p.has_lknumbers,
    p.treating_hospital_id,
    h.description AS treating_hospital,
    p.treating_physician,
    p.consent,
    p.consent_pdx,
    p.consent_details,
    p.birth_year,
    p.birth_year_month_date,
    p.sex_id,
    s.description AS sex,
    p.diagnosis_id,
    d.description AS diagnosis,
    p.subtype_id,
    st.description AS subtype,
    p.egil_fab_id,
    e.description AS egil_fab,
    p.etp,
    p.in_fedrral
   FROM (((((patient p
     LEFT JOIN "ref-hospital" h ON ((p.treating_hospital_id = h.id)))
     LEFT JOIN "ref-sex" s ON ((p.sex_id = s.id)))
     LEFT JOIN "ref-diagnosis" d ON ((p.diagnosis_id = d.id)))
     LEFT JOIN "ref-egil_fab" e ON ((p.egil_fab_id = e.id)))
     LEFT JOIN "ref-subtype" st ON ((p.subtype_id = st.id)));


CREATE TABLE plate (
    plate_id integer NOT NULL,
    layout_id integer NOT NULL,
    measurement_id integer NOT NULL,
    manual_normalization boolean,
    manual_dmso_mean real,
    assay_id integer NOT NULL,
    tenant_id character varying,
    user_id character varying,
    include_current_lot boolean,
    control_wells_t18 character varying,
    control_wells_t96 character varying,
    comment character varying
);



CREATE VIEW plate_view AS
 SELECT p.plate_id,
    ((((('M'::text || p.measurement_id) || '-L'::text) || p.layout_id) || '-A'::text) || p.assay_id) AS mla,
    p.measurement_id,
    p.layout_id,
    p.assay_id,
    m.plate_no,
    a.assay_description,
    s.sid,
    s.lknumber,
    p.manual_normalization,
    p.manual_dmso_mean,
    p.control_wells_t18,
    p.control_wells_t96,
    m.img_well_coverage,
    a.cancer_seeded
   FROM (((plate p
     LEFT JOIN assay a ON ((p.assay_id = a.assay_id)))
     LEFT JOIN measurement m ON ((p.measurement_id = m.measurement_id)))
     LEFT JOIN sample s ON ((a.sid = s.sid)));



CREATE VIEW plate_material_view AS
 SELECT DISTINCT pv.plate_id,
    pv.layout_id,
    av.assay_id,
    COALESCE(pv.sid, lcv.sid_material, av.sid) AS sid,
    COALESCE(pv.lknumber, lcv.lknumber_material, av.lknumber) AS lknumber
   FROM ((plate_view pv
     RIGHT JOIN assay_view av ON ((pv.assay_id = av.assay_id)))
     LEFT JOIN layout_content_view lcv ON ((pv.layout_id = lcv.layout_id)));



CREATE VIEW psa_view AS
 SELECT DISTINCT ON (pmv.sid, pmv.lknumber, pmv.assay_id) sv.pid,
    pmv.sid,
    pmv.lknumber,
    pmv.assay_id,
    av.assay_description,
    pv.patient_crossref,
    pv.has_lknumbers,
    pv.treating_hospital_id,
    pv.treating_hospital,
    pv.treating_physician,
    pv.consent,
    pv.consent_pdx,
    pv.consent_details,
    pv.birth_year,
    pv.birth_year_month_date,
    pv.sex_id,
    pv.sex,
    pv.diagnosis_id,
    pv.diagnosis,
    pv.subtype_id,
    pv.subtype,
    pv.egil_fab_id,
    pv.egil_fab,
    pv.etp,
    pv.in_fedrral,
    sv.lkyear,
    sv.sample_crossref,
    sv.inform,
    sv.clinical_trial,
    sv.country_id,
    sv.country,
    sv.city,
    sv.disease_stage_id,
    sv.disease_stage,
    sv.puncture_date,
    sv.timepoint_collection,
    sv.cancer_fraction,
    sv.tissue_id,
    sv.tissue,
    sv.collection_method_id,
    sv.collection_method,
    av.fresh,
    sv.mio_cells_shipped,
    sv.cell_isolation_id,
    sv.cell_isolation,
    sv.anticoagulant_id,
    sv.anticoagulant,
    sv.shipping_medium,
    sv.sending_hospital_id,
    sv.sending_hospital,
    sv.correspondence,
    sv.sending_date,
    sv.arrival_date,
    sv.reporting_date,
    sv.exclude_sample,
    sv.sent_for_pdx,
    av.origin_id,
    av.origin,
    av.drp_hospital_id,
    av.drp_hospital,
    av.drp_date,
    av.msc_passage,
    av.msc_seeded,
    av.fraction_msc_detached,
    av.msc_detached_id,
    av.msc_detached,
    av.cancer_thawing,
    av.cancer_passage,
    av.cancer_seeded,
    av.cancer_18h,
    av.coverage_18h,
    av.drug_exposure_hours,
    av.marker_based,
    av.medium_id,
    av.medium,
    av.medium_supplement,
    av.coating_id,
    av.coating,
    av.contaminated_id,
    av.contaminated,
    av.assay_failed,
    av.is_combination,
    av.assay_reported
   FROM (((plate_material_view pmv
     LEFT JOIN assay_view av USING (assay_id))
     LEFT JOIN sample_view sv ON ((pmv.sid = sv.sid)))
     LEFT JOIN patient_view pv USING (pid))
  ORDER BY pmv.sid, pmv.lknumber, pmv.assay_id;



CREATE VIEW cohort_psa_view AS
 SELECT c.cohort_id,
    c.cohort_name,
    psa.pid,
    psa.sid,
    psa.lknumber,
    psa.assay_id,
    psa.assay_description,
    psa.patient_crossref,
    psa.has_lknumbers,
    psa.treating_hospital_id,
    psa.treating_hospital,
    psa.treating_physician,
    psa.consent,
    psa.consent_pdx,
    psa.consent_details,
    psa.birth_year,
    psa.birth_year_month_date,
    psa.sex_id,
    psa.sex,
    psa.diagnosis_id,
    psa.diagnosis,
    psa.subtype_id,
    psa.subtype,
    psa.egil_fab_id,
    psa.egil_fab,
    psa.etp,
    psa.in_fedrral,
    psa.lkyear,
    psa.sample_crossref,
    psa.inform,
    psa.clinical_trial,
    psa.country_id,
    psa.country,
    psa.city,
    psa.disease_stage_id,
    psa.disease_stage,
    psa.puncture_date,
    psa.timepoint_collection,
    psa.cancer_fraction,
    psa.tissue_id,
    psa.tissue,
    psa.collection_method_id,
    psa.collection_method,
    psa.fresh,
    psa.mio_cells_shipped,
    psa.cell_isolation_id,
    psa.cell_isolation,
    psa.anticoagulant_id,
    psa.anticoagulant,
    psa.shipping_medium,
    psa.sending_hospital_id,
    psa.sending_hospital,
    psa.correspondence,
    psa.sending_date,
    psa.arrival_date,
    psa.reporting_date,
    psa.exclude_sample,
    psa.sent_for_pdx,
    psa.origin_id,
    psa.origin,
    psa.drp_hospital_id,
    psa.drp_hospital,
    psa.drp_date,
    psa.msc_passage,
    psa.msc_seeded,
    psa.fraction_msc_detached,
    psa.msc_detached_id,
    psa.msc_detached,
    psa.cancer_thawing,
    psa.cancer_passage,
    psa.cancer_seeded,
    psa.cancer_18h,
    psa.coverage_18h,
    psa.drug_exposure_hours,
    psa.marker_based,
    psa.medium_id,
    psa.medium,
    psa.medium_supplement,
    psa.coating_id,
    psa.coating,
    psa.contaminated_id,
    psa.contaminated,
    psa.assay_failed,
    psa.is_combination,
    psa.assay_reported
   FROM ((cohort c
     LEFT JOIN cohort__assay_sample ca ON ((c.cohort_id = ca.cohort_id)))
     JOIN psa_view psa ON (((ca.assay_id = psa.assay_id) AND (ca.sid = psa.sid))));


CREATE TABLE cohort_stats (
    cohort_id integer NOT NULL,
    drug_id integer NOT NULL,
    metric character varying NOT NULL,
    mean real,
    sd real,
    median real,
    mad real,
    p25 real,
    p75 real,
    tenant_id character varying,
    user_id character varying,
    p10 real,
    p90 real,
    min real,
    max real,
    p5 real,
    p95 real
);


CREATE TABLE drc_model (
    drug_id integer NOT NULL,
    model oid,
    plate_id integer NOT NULL
);


CREATE TABLE drc_prediction (
    plate_id integer NOT NULL,
    drug_id integer NOT NULL,
    concentration real NOT NULL,
    norm_response real,
    norm_response_lower real,
    norm_response_upper real,
    unit_id integer,
    tenant_id character varying,
    user_id character varying,
    readout_id integer NOT NULL,
    sid integer NOT NULL
);


CREATE VIEW drc_prediction_view AS
 SELECT pd.plate_id,
    pd.drug_id,
    pd.concentration,
    pd.norm_response,
    pd.norm_response_lower,
    pd.norm_response_upper,
    pd.unit_id,
    pd.tenant_id,
    pd.user_id,
    pd.readout_id,
    pmv.sid,
    pmv.lknumber,
    u.description AS unit
   FROM ((drc_prediction pd
     LEFT JOIN plate_material_view pmv ON (((pd.plate_id = pmv.plate_id) AND (pd.sid = pmv.sid))))
     LEFT JOIN "ref-unit" u ON ((pd.unit_id = u.id)))
  ORDER BY pd.plate_id, pd.drug_id, pd.concentration;


CREATE TABLE drug__functional_class (
    drug_id integer NOT NULL,
    functional_class_id integer NOT NULL,
    user_id character varying,
    tenant_id character varying
);



CREATE TABLE drug__synonym (
    drug_id integer NOT NULL,
    synonym character varying NOT NULL,
    user_id character varying,
    tenant_id character varying
);



CREATE TABLE drug__target (
    drug_id integer NOT NULL,
    target_id integer NOT NULL
);



CREATE TABLE drug_stock (
    drug_id integer NOT NULL,
    min_assay_conc real,
    max_assay_conc real,
    n_doses integer,
    stock_conc integer,
    priority integer,
    plate_priority integer,
    stock_well character varying,
    max_master_conc integer,
    replicates integer,
    solvent_id integer,
    stock_plate_no integer,
    user_id character varying,
    tenant_id character varying NOT NULL
);


CREATE VIEW functional_class_view AS
 SELECT dfc.drug_id,
    dfc.functional_class_id,
    fc.description AS functional_class
   FROM (drug__functional_class dfc
     LEFT JOIN "ref-functional_class" fc ON ((dfc.functional_class_id = fc.id)));


CREATE VIEW public.drug_view AS
SELECT
    NULL::integer AS drug_id,
    NULL::character varying AS drug_name,
    NULL::character varying AS kispi_id,
    NULL::character varying AS abbreviation,
    NULL::text AS synonyms,
    NULL::real AS min_assay_conc,
    NULL::real AS max_assay_conc,
    NULL::integer AS unit_id,
    NULL::character varying AS unit,
    NULL::text AS functional_classes_id,
    NULL::text AS functional_classes,
    NULL::text AS biological_processes_id,
    NULL::text AS biological_processes,
    NULL::integer AS n_doses,
    NULL::integer AS stock_conc,
    NULL::real AS max_master_conc,
    NULL::bigint AS stock_plate_no,
    NULL::character varying AS stock_well,
    NULL::integer AS replicates,
    NULL::integer AS plate_priority,
    NULL::integer AS priority,
    NULL::integer AS solvent_id,
    NULL::character varying AS solvent,
    NULL::character varying AS cas_number;


CREATE VIEW drug_view_long AS
 SELECT d.drug_id,
    d.drug_name,
    d.kispi_id,
    COALESCE(d.abbreviation, d.drug_name) AS abbreviation,
    d.min_assay_conc,
    d.max_assay_conc,
    fcv.functional_class_id,
    fcv.functional_class,
    bpv.biological_process_id,
    bpv.biological_process,
    d.plate_priority,
    d.priority
   FROM ((drug d
     LEFT JOIN functional_class_view fcv ON ((d.drug_id = fcv.drug_id)))
     LEFT JOIN biological_process_view bpv ON ((d.drug_id = bpv.drug_id)));


CREATE TABLE parameter (
    plate_id integer NOT NULL,
    drug_id integer NOT NULL,
    f real,
    e real,
    d real,
    c real,
    b real,
    fitmodel character varying,
    tenant_id character varying,
    user_id character varying,
    rse real,
    readout_id integer NOT NULL,
    sid integer NOT NULL
);


CREATE TABLE stage (
    stage_id integer NOT NULL,
    stage_date date,
    stage_cancer_fraction real,
    pid integer NOT NULL,
    disease_stage_id integer,
    cns_status_id integer,
    localization_details character varying,
    localization_id integer,
    sid_d0 integer,
    sample_for_drp boolean,
    risk_id integer,
    refractory boolean,
    tenant_id character varying,
    user_id character varying,
    tissue_id integer,
    comment character varying,
    relapse_time_id integer,
    giga_blast_count_per_liter integer,
    stage_method_id integer,
    diagnosis_id integer
);


CREATE VIEW stage_view AS
 SELECT s.stage_id,
    s.pid,
    p.has_lknumbers,
    s.disease_stage_id,
    ds.description AS disease_stage,
    s.stage_date,
    s.diagnosis_id,
    d.description AS diagnosis,
    s.stage_cancer_fraction,
    s.stage_method_id,
    rm.description AS stage_method,
    s.giga_blast_count_per_liter,
    s.risk_id,
    r.description AS risk,
    s.tissue_id,
    t.description AS tissue,
    s.refractory,
    s.localization_id,
    l.description AS localization,
    s.localization_details,
    s.cns_status_id,
    cn.description AS cns_status,
    s.sample_for_drp,
    s.sid_d0,
    sa.lknumber,
    s.relapse_time_id,
    rt.description AS relapse_time
   FROM ((((((((((stage s
     LEFT JOIN "ref-disease_stage" ds ON ((s.disease_stage_id = ds.id)))
     LEFT JOIN "ref-tissue" t ON ((s.tissue_id = t.id)))
     LEFT JOIN "ref-risk" r ON ((s.risk_id = r.id)))
     LEFT JOIN "ref-localization" l ON ((s.localization_id = l.id)))
     LEFT JOIN "ref-cns_status" cn ON ((s.cns_status_id = cn.id)))
     LEFT JOIN "ref-relapse_time" rt ON ((s.relapse_time_id = rt.id)))
     LEFT JOIN "ref-response_method" rm ON ((s.stage_method_id = rm.id)))
     LEFT JOIN "ref-diagnosis" d ON ((s.diagnosis_id = d.id)))
     LEFT JOIN patient p ON ((s.pid = p.pid)))
     LEFT JOIN sample sa ON ((s.sid_d0 = sa.sid)));


CREATE VIEW feature_view AS
 SELECT pv.pid,
    pmv.sid,
    pmv.lknumber,
    pmv.assay_id,
    pv.patient_crossref,
    pv.birth_year,
    pv.birth_year_month_date,
    pv.sex_id,
    pv.sex,
    pv.diagnosis_id,
    pv.diagnosis,
    pv.subtype_id,
    pv.subtype,
    pv.egil_fab_id,
    pv.egil_fab,
    pv.etp,
    pv.in_fedrral,
    sv.lkyear,
    sv.sample_crossref,
    sv.country,
    sv.city,
    sv.disease_stage_id,
    sv.disease_stage,
    sv.puncture_date,
    sv.timepoint_collection,
    sv.cancer_fraction,
    sv.tissue_id,
    sv.tissue,
    sv.collection_method_id,
    sv.collection_method,
    av.fresh,
    av.assay_description,
    av.drp_date,
    av.origin_id,
    av.origin,
    av.fraction_msc_detached,
    av.msc_detached_id,
    av.msc_detached,
    av.cancer_thawing,
    av.cancer_passage,
    av.cancer_seeded,
    av.cancer_18h,
    av.coverage_18h,
    av.drug_exposure_hours,
    av.marker_based,
    av.medium_id,
    av.medium,
    av.medium_supplement,
    av.coating_id,
    av.coating,
    av.contaminated_id,
    av.contaminated,
    av.assay_failed,
    av.is_combination,
    av.assay_reported,
    stv.relapse_time,
    stv.stage_cancer_fraction,
    stv.giga_blast_count_per_liter,
    stv.risk,
    stv.refractory,
    stv.localization,
    stv.cns_status,
    pmv.plate_id,
    drug_view.drug_id,
    drug_view.drug_name,
    drug_view.plate_priority,
    drug_view.priority,
    drug_view.biological_processes,
    drug_view.functional_classes_id,
    drug_view.functional_classes,
    parameter.readout_id,
    r.description AS readout,
    parameter.fitmodel,
    parameter.b,
    parameter.c,
    parameter.d,
    parameter.e,
    parameter.f,
    parameter.rse
   FROM (((((((plate_material_view pmv
     LEFT JOIN assay_view av USING (assay_id))
     LEFT JOIN sample_view sv ON ((pmv.sid = sv.sid)))
     LEFT JOIN patient_view pv USING (pid))
     LEFT JOIN stage_view stv USING (pid, disease_stage_id))
     JOIN parameter ON (((parameter.plate_id = pmv.plate_id) AND (parameter.sid = pmv.sid))))
     LEFT JOIN drug_view USING (drug_id))
     LEFT JOIN "ref-readout" r ON ((r.id = parameter.readout_id)))
  ORDER BY pv.pid, pmv.sid, pmv.lknumber, pmv.assay_id;


CREATE TABLE flow (
    flow_id integer NOT NULL,
    pid integer NOT NULL,
    disease_stage_id integer,
    marker_id integer NOT NULL,
    expression_id integer,
    tenant_id character varying,
    user_id character varying
);


CREATE VIEW flow_view AS
 SELECT ct.flow_id,
    ct.pid,
    ct.has_lknumbers,
    ct.disease_stage_id,
    ct.disease_stage,
    ct.negative,
    ct.weak,
    ct.strong
   FROM crosstab('SELECT flow_id, pid, has_lknumbers, disease_stage_id, disease_stage, expression, markers
    FROM flow_view_long ORDER BY 1'::text, 'VALUES (''negative''), (''weak''), (''strong'')'::text) ct(flow_id integer, pid integer, has_lknumbers character varying, disease_stage_id integer, disease_stage character varying, negative character varying, weak character varying, strong character varying);


CREATE VIEW flow_view_long AS
 SELECT f.flow_id,
    f.pid,
    p.has_lknumbers,
    f.disease_stage_id,
    ds.description AS disease_stage,
    f.expression_id,
    e.description AS expression,
    string_agg((m.description)::text, ', '::text ORDER BY (m.description)::text) AS markers
   FROM ((((flow f
     LEFT JOIN patient p ON ((f.pid = p.pid)))
     LEFT JOIN "ref-disease_stage" ds ON ((f.disease_stage_id = ds.id)))
     LEFT JOIN "ref-marker" m ON ((f.marker_id = m.id)))
     LEFT JOIN "ref-expression" e ON ((f.expression_id = e.id)))
  GROUP BY f.flow_id, f.pid, p.has_lknumbers, ds.description, f.disease_stage_id, f.expression_id, e.description;


CREATE TABLE genetics (
    genetic_id integer NOT NULL,
    pid integer NOT NULL,
    disease_stage_id integer,
    gene_id integer,
    alteration_id integer,
    karyotype character varying,
    "position" character varying,
    vaf real,
    fusion_partner_id integer,
    gene_signature_id integer,
    tenant_id character varying,
    user_id character varying,
    functional_consequence_id integer,
    comment character varying,
    tmb real,
    inform_priority real,
    chromosomal_aberration_id integer
);


CREATE VIEW genetics_view AS
 SELECT g.genetic_id,
    g.pid,
    p.has_lknumbers,
    g.disease_stage_id,
    ds.description AS disease_stage,
    g.gene_id,
    gn.description AS gene,
    g.alteration_id,
    a.description AS alteration,
    g."position",
    g.vaf,
    g.fusion_partner_id,
    gn2.description AS fusion_partner,
    g.chromosomal_aberration_id,
    ca.description AS chromosomal_aberration,
    g.karyotype,
    g.gene_signature_id,
    gs.description AS gene_signature,
    g.tmb,
    g.inform_priority,
    g.functional_consequence_id,
    fc.description AS functional_consequence,
    g.comment
   FROM ((((((((genetics g
     LEFT JOIN patient p ON ((g.pid = p.pid)))
     LEFT JOIN "ref-disease_stage" ds ON ((g.disease_stage_id = ds.id)))
     LEFT JOIN "ref-gene" gn ON ((g.gene_id = gn.id)))
     LEFT JOIN "ref-gene" gn2 ON ((g.fusion_partner_id = gn2.id)))
     LEFT JOIN "ref-gene_signature" gs ON ((g.gene_signature_id = gs.id)))
     LEFT JOIN "ref-alteration" a ON ((g.alteration_id = a.id)))
     LEFT JOIN "ref-functional_consequence" fc ON ((g.functional_consequence_id = fc.id)))
     LEFT JOIN "ref-chromosomal_aberration" ca ON ((g.chromosomal_aberration_id = ca.id)));


CREATE TABLE kinetic (
    kinetic_id integer NOT NULL,
    mouse_id integer,
    measurement_date date,
    percentage_cd45 real,
    percentage_cd19 real,
    percentage_cd7 real,
    tenant_id character varying,
    user_id character varying
);


CREATE TABLE layout (
    layout_id integer NOT NULL,
    type_id integer,
    format_id integer,
    name character varying,
    tenant_id character varying,
    user_id character varying
);


CREATE VIEW layout_view AS
 SELECT l.layout_id,
    l.name,
    l.type_id,
    lt.description AS type,
    l.format_id,
    lf.description AS format
   FROM ((layout l
     LEFT JOIN "ref-layout_type" lt ON ((l.type_id = lt.id)))
     LEFT JOIN "ref-plate_format" lf ON ((l.format_id = lf.id)));


CREATE TABLE lot (
    lot_id integer NOT NULL,
    lot character varying,
    opening_date date,
    drug_id integer,
    comment character varying,
    user_id character varying,
    tenant_id character varying,
    vendor character varying,
    catalog_number character varying
);


CREATE VIEW lot_view AS
 SELECT lot.lot_id,
    lot.lot,
    drug.drug_name,
    lot.vendor,
    lot.catalog_number,
    lot.opening_date,
    lot.comment
   FROM (lot
     LEFT JOIN drug ON ((lot.drug_id = drug.drug_id)));


CREATE TABLE measurement_content (
    measurement_id integer NOT NULL,
    "row" character varying NOT NULL,
    col integer NOT NULL,
    response numeric,
    exclude boolean,
    tenant_id character varying,
    user_id character varying,
    exclude_reason character varying,
    readout_id integer NOT NULL,
    marker_ids character varying
);


CREATE VIEW "ref-marker_view" AS
 SELECT "ref-marker".id,
    "ref-marker".description
   FROM "ref-marker"
UNION ALL
 SELECT (- "ref-marker".id) AS id,
    ('-'::text || ("ref-marker".description)::text) AS description
   FROM "ref-marker"
  WHERE (("ref-marker".id <> 0) AND ("ref-marker".id <> '-1000'::integer));


CREATE VIEW measurement_content_view AS
 SELECT mc.measurement_id,
    mc."row",
    mc.col,
    mc.response,
    mc.readout_id,
    r.description AS readout,
    mc.marker_ids,
    string_agg((m.description)::text, ', '::text) AS markers,
    mc.exclude,
    mc.exclude_reason
   FROM (((measurement_content mc
     LEFT JOIN LATERAL regexp_split_to_table((mc.marker_ids)::text, ','::text) s(s) ON (true))
     LEFT JOIN "ref-marker_view" m ON (((s.s)::integer = m.id)))
     LEFT JOIN "ref-readout" r ON ((mc.readout_id = r.id)))
  GROUP BY mc.measurement_id, mc."row", mc.col, mc.response, mc.readout_id, r.description, mc.marker_ids, mc.exclude, mc.exclude_reason;


CREATE VIEW measurement_marker_view AS
 SELECT DISTINCT mcv.measurement_id,
    mcv.marker_ids,
    mcv.markers
   FROM measurement_content_view mcv;


CREATE VIEW measurement_view AS
 SELECT m.measurement_id,
    m.plate_no,
    m.name,
    m.format_id,
    pf.description AS format,
    m.modality_id,
    md.description AS modality,
    m.resolution_id,
    rs.description AS resolution,
    m.img_well_coverage,
    m.bias,
    m.confocal
   FROM (((measurement m
     LEFT JOIN "ref-plate_format" pf ON ((m.format_id = pf.id)))
     LEFT JOIN "ref-modality" md ON ((m.modality_id = md.id)))
     LEFT JOIN "ref-resolution" rs ON ((m.resolution_id = rs.id)));


CREATE TABLE normalization_content (
    measurement_id integer NOT NULL,
    "row" character varying NOT NULL,
    col integer NOT NULL,
    norm_response real,
    plate_id integer NOT NULL,
    readout_id integer NOT NULL,
    tenant_id character varying,
    user_id character varying
);


CREATE VIEW parameter_view AS
 SELECT p.plate_id,
    pmv.assay_id,
    pmv.sid,
    pmv.lknumber,
    p.readout_id,
    r.description AS readout,
    p.drug_id,
    d.drug_name,
    p.f,
    p.e,
    p.d,
    p.c,
    p.b,
    p.fitmodel,
    p.rse
   FROM (((parameter p
     LEFT JOIN plate_material_view pmv USING (plate_id))
     LEFT JOIN "ref-readout" r ON ((r.id = p.readout_id)))
     LEFT JOIN drug d ON ((d.drug_id = p.drug_id)));


CREATE VIEW plate_content_view AS
 SELECT pv.plate_id,
    lcv.layout_id,
    mcv.measurement_id,
    pv.assay_id,
    pv.assay_description,
    COALESCE(pv.sid, lcv.sid_material) AS sid,
    COALESCE(pv.lknumber, lcv.lknumber_material) AS lknumber,
    lcv.material_id,
    mcv."row",
    mcv.col,
    lcv.drug_id,
    lcv.drug_name,
    lcv.concentration,
    lcv.unit_id,
    lcv.unit,
    lcv.medium_id,
    lcv.medium,
    lcv.lot,
    mcv.readout_id,
    mcv.readout,
    mcv.marker_ids,
    mcv.markers,
    mcv.response,
    nc.norm_response,
    lcv.condition_index,
    mcv.exclude,
    mcv.exclude_reason,
    nc.user_id,
    nc.tenant_id
   FROM (((plate_view pv
     LEFT JOIN measurement_content_view mcv ON ((pv.measurement_id = mcv.measurement_id)))
     LEFT JOIN normalization_content nc ON (((pv.measurement_id = nc.measurement_id) AND ((mcv."row")::text = (nc."row")::text) AND (mcv.col = nc.col) AND (mcv.readout_id = nc.readout_id))))
     LEFT JOIN layout_content_view lcv ON (((pv.layout_id = lcv.layout_id) AND ((mcv."row")::text = (lcv."row")::text) AND (mcv.col = lcv.col))));


CREATE VIEW pssa_view AS
 SELECT DISTINCT ON (pmv.sid, pmv.lknumber, pmv.assay_id) sv.pid,
    pmv.sid,
    pmv.lknumber,
    pmv.assay_id,
    av.assay_description,
    pv.patient_crossref,
    pv.has_lknumbers AS treating_hospital_id,
    pv.treating_hospital,
    pv.treating_physician,
    pv.consent,
    pv.consent_pdx,
    pv.consent_details,
    pv.birth_year,
    pv.birth_year_month_date,
    pv.sex_id,
    pv.sex,
    pv.diagnosis_id,
    pv.diagnosis,
    pv.subtype_id,
    pv.subtype,
    pv.egil_fab_id,
    pv.egil_fab,
    pv.etp,
    pv.in_fedrral,
    sv.lkyear,
    sv.sample_crossref,
    sv.inform,
    sv.clinical_trial,
    sv.country_id,
    sv.country,
    sv.city,
    sv.disease_stage_id,
    sv.disease_stage,
    sv.puncture_date,
    sv.timepoint_collection,
    sv.cancer_fraction,
    sv.tissue_id,
    sv.tissue,
    sv.collection_method_id,
    sv.collection_method,
    av.fresh,
    sv.mio_cells_shipped,
    sv.cell_isolation_id,
    sv.cell_isolation,
    sv.anticoagulant_id,
    sv.anticoagulant,
    sv.shipping_medium,
    sv.sending_hospital_id,
    sv.sending_hospital,
    sv.correspondence,
    sv.sending_date,
    sv.arrival_date,
    sv.reporting_date,
    sv.exclude_sample,
    sv.sent_for_pdx,
    av.origin_id,
    av.origin,
    av.drp_hospital_id,
    av.drp_hospital,
    av.drp_date,
    av.msc_passage,
    av.msc_seeded,
    av.fraction_msc_detached,
    av.msc_detached_id,
    av.msc_detached,
    av.cancer_thawing,
    av.cancer_passage,
    av.cancer_seeded,
    av.cancer_18h,
    av.coverage_18h,
    av.drug_exposure_hours,
    av.marker_based,
    av.medium_id,
    av.medium,
    av.medium_supplement,
    av.coating_id,
    av.coating,
    av.contaminated_id,
    av.contaminated,
    av.assay_failed,
    av.is_combination,
    av.assay_reported,
    stv.relapse_time,
    stv.stage_cancer_fraction,
    stv.giga_blast_count_per_liter,
    stv.risk,
    stv.refractory,
    stv.localization,
    stv.cns_status
   FROM ((((plate_material_view pmv
     LEFT JOIN assay_view av USING (assay_id))
     LEFT JOIN sample_view sv ON ((pmv.sid = sv.sid)))
     LEFT JOIN patient_view pv USING (pid))
     LEFT JOIN stage_view stv USING (pid, disease_stage_id))
  ORDER BY pmv.sid, pmv.lknumber, pmv.assay_id;


-- Constraints -----------------------------------------------------------------

ALTER TABLE ONLY public."ref-alteration"
    ADD CONSTRAINT alteration_pk1 PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-anticoagulant"
    ADD CONSTRAINT anticoagulant_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.assay
    ADD CONSTRAINT assay_pkey PRIMARY KEY (assay_id);

ALTER TABLE ONLY public."ref-biological_process"
    ADD CONSTRAINT biological_process_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-cell_isolation"
    ADD CONSTRAINT cell_isolation_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-cns_status"
    ADD CONSTRAINT cns_status_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.cohort__assay_sample
    ADD CONSTRAINT cohort__assay_sample_pk PRIMARY KEY (cohort_id, assay_id, sid);

ALTER TABLE ONLY public.cohort
    ADD CONSTRAINT cohort_pk1 PRIMARY KEY (cohort_id);

ALTER TABLE ONLY public.cohort_stats
    ADD CONSTRAINT cohort_stats_pk PRIMARY KEY (cohort_id, drug_id, metric);

ALTER TABLE ONLY public."ref-disease_stage"
    ADD CONSTRAINT disease_stage_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.drc_model
    ADD CONSTRAINT drc_model_pk PRIMARY KEY (plate_id, drug_id);

ALTER TABLE ONLY public.drc_prediction
    ADD CONSTRAINT drc_prediction_pk PRIMARY KEY (plate_id, drug_id, concentration, readout_id, sid);

ALTER TABLE ONLY public.drug__biological_process
    ADD CONSTRAINT drug__biological_process_pk PRIMARY KEY (drug_id, biological_process_id);

ALTER TABLE ONLY public.drug__functional_class
    ADD CONSTRAINT drug__functional_class_pk PRIMARY KEY (drug_id, functional_class_id);

ALTER TABLE ONLY public.drug__target
    ADD CONSTRAINT drug__target_pk PRIMARY KEY (drug_id, target_id);

ALTER TABLE ONLY public.layout_content
    ADD CONSTRAINT drug_layout_pk PRIMARY KEY (layout_id, "row", col, drug_id);

ALTER TABLE ONLY public.drug__synonym
    ADD CONSTRAINT drug_names_pk PRIMARY KEY (synonym, drug_id);

ALTER TABLE ONLY public.drug
    ADD CONSTRAINT drug_pkey PRIMARY KEY (drug_id);

ALTER TABLE ONLY public.drug_stock
    ADD CONSTRAINT drug_stock_pk PRIMARY KEY (drug_id, tenant_id);

ALTER TABLE ONLY public."ref-egil_fab"
    ADD CONSTRAINT egil_t_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-ethnicity"
    ADD CONSTRAINT ethnicity_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.stage
    ADD CONSTRAINT event_pk1 PRIMARY KEY (stage_id);

ALTER TABLE ONLY public.flow
    ADD CONSTRAINT flow_pk PRIMARY KEY (flow_id, marker_id);

ALTER TABLE ONLY public."ref-functional_class"
    ADD CONSTRAINT fn_class_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-gene"
    ADD CONSTRAINT gene_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.genetics
    ADD CONSTRAINT genetics_pk1 PRIMARY KEY (genetic_id);

ALTER TABLE ONLY public.genetics
    ADD CONSTRAINT genetics_unique UNIQUE NULLS NOT DISTINCT (pid, gene_id, disease_stage_id, alteration_id, "position", fusion_partner_id, chromosomal_aberration_id, karyotype, tmb);

ALTER TABLE ONLY public."ref-hospital"
    ADD CONSTRAINT hospital_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-diagnosis"
    ADD CONSTRAINT immunophenotype_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.kinetic
    ADD CONSTRAINT kinetic_pk PRIMARY KEY (kinetic_id);

ALTER TABLE ONLY public.layout
    ADD CONSTRAINT layout_pk PRIMARY KEY (layout_id);

ALTER TABLE ONLY public."ref-lineage"
    ADD CONSTRAINT lineage_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT lknumber_unique UNIQUE (lknumber);

ALTER TABLE ONLY public.lot
    ADD CONSTRAINT lot_pk PRIMARY KEY (lot_id);

ALTER TABLE ONLY public."ref-expression"
    ADD CONSTRAINT marker_expr_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-marker"
    ADD CONSTRAINT marker_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-origin"
    ADD CONSTRAINT material_origin_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pk PRIMARY KEY (material_id);

ALTER TABLE ONLY public.measurement_content
    ADD CONSTRAINT measurement_content_pk PRIMARY KEY (measurement_id, "row", col, readout_id);

ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_pk PRIMARY KEY (measurement_id);

ALTER TABLE ONLY public."ref-medium"
    ADD CONSTRAINT medium_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.normalization_content
    ADD CONSTRAINT normalization_content_pk PRIMARY KEY (measurement_id, "row", col, readout_id);

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT parameter_pk PRIMARY KEY (plate_id, drug_id, readout_id, sid);

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pk PRIMARY KEY (pid);

ALTER TABLE ONLY public.plate
    ADD CONSTRAINT plate_pk PRIMARY KEY (plate_id);

ALTER TABLE ONLY public.plate
    ADD CONSTRAINT plate_unique UNIQUE (layout_id, measurement_id, assay_id);

ALTER TABLE ONLY public."ref-plate_format"
    ADD CONSTRAINT plateformat_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-layout_type"
    ADD CONSTRAINT platetype_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-protocol"
    ADD CONSTRAINT protocol_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-readout"
    ADD CONSTRAINT readout_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-approval_status"
    ADD CONSTRAINT ref_approval_status_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-chromosomal_aberration"
    ADD CONSTRAINT ref_chromosomal_aberration_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-chromosomal_aberration"
    ADD CONSTRAINT ref_chromosomal_aberration_unique UNIQUE (description);

ALTER TABLE ONLY public."ref-coating"
    ADD CONSTRAINT ref_coating_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-coating"
    ADD CONSTRAINT ref_coating_unique UNIQUE (description);

ALTER TABLE ONLY public."ref-collection_method"
    ADD CONSTRAINT ref_collection_method_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-collection_method"
    ADD CONSTRAINT ref_collection_method_unique UNIQUE (description);

ALTER TABLE ONLY public."ref-contamination"
    ADD CONSTRAINT ref_contamination_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-country"
    ADD CONSTRAINT ref_country_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-death_cause"
    ADD CONSTRAINT ref_death_cause_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-echo_plate"
    ADD CONSTRAINT ref_echo_plate_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-echo_plate"
    ADD CONSTRAINT ref_echo_plate_unique UNIQUE (class, solvent);

ALTER TABLE ONLY public."ref-fitmodel"
    ADD CONSTRAINT ref_fitmodel_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-functional_consequence"
    ADD CONSTRAINT ref_functional_consequence_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-functional_consequence"
    ADD CONSTRAINT ref_functional_consequence_un UNIQUE (description);

ALTER TABLE ONLY public."ref-gene_signature"
    ADD CONSTRAINT ref_gene_signature_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-gene_signature"
    ADD CONSTRAINT ref_gene_signature_un UNIQUE (description);

ALTER TABLE ONLY public."ref-localization"
    ADD CONSTRAINT ref_localization_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-marker_category"
    ADD CONSTRAINT ref_marker_category_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-modality"
    ADD CONSTRAINT ref_modality_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-modality"
    ADD CONSTRAINT ref_modality_unique UNIQUE (description);

ALTER TABLE ONLY public."ref-msc_detachment"
    ADD CONSTRAINT ref_msc_detachment_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-organ"
    ADD CONSTRAINT ref_organ_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-protocol"
    ADD CONSTRAINT ref_protocol_unique UNIQUE (description);

ALTER TABLE ONLY public."ref-reader_function"
    ADD CONSTRAINT ref_reader_function_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-resolution"
    ADD CONSTRAINT ref_resolution_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-risk"
    ADD CONSTRAINT ref_risk_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-solvent"
    ADD CONSTRAINT ref_solvent_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-solvent"
    ADD CONSTRAINT ref_solvent_un UNIQUE (description);

ALTER TABLE ONLY public."ref-target"
    ADD CONSTRAINT ref_target_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-ordered_feature"
    ADD CONSTRAINT reference_type_pk PRIMARY KEY (feature);

ALTER TABLE ONLY public."ref-response_assessment"
    ADD CONSTRAINT response_assessement_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-response_method"
    ADD CONSTRAINT response_method_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-response_mrd"
    ADD CONSTRAINT response_mrd_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT sample_pkey PRIMARY KEY (sid);

ALTER TABLE ONLY public."ref-sex"
    ADD CONSTRAINT sex_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-subtype"
    ADD CONSTRAINT subtype_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-relapse_time"
    ADD CONSTRAINT time_relapse_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-tissue"
    ADD CONSTRAINT tissue_pk PRIMARY KEY (id);

ALTER TABLE ONLY public."ref-unit"
    ADD CONSTRAINT unit_pk PRIMARY KEY (id);

CREATE UNIQUE INDEX alteration_un1 ON public."ref-alteration" USING btree (description);

CREATE UNIQUE INDEX anticoagulant_un ON public."ref-anticoagulant" USING btree (description);

CREATE UNIQUE INDEX biological_process_un ON public."ref-biological_process" USING btree (description);

CREATE UNIQUE INDEX cell_isolation_un ON public."ref-cell_isolation" USING btree (description);

CREATE UNIQUE INDEX cns_status_un ON public."ref-cns_status" USING btree (description);

CREATE UNIQUE INDEX disease_stage_un ON public."ref-disease_stage" USING btree (description);

CREATE UNIQUE INDEX egil_t_un ON public."ref-egil_fab" USING btree (description);

CREATE UNIQUE INDEX ethnicity_un ON public."ref-ethnicity" USING btree (description);

CREATE UNIQUE INDEX event_un2 ON public.stage USING btree (pid, disease_stage_id);

CREATE UNIQUE INDEX fn_class_un ON public."ref-functional_class" USING btree (description);

CREATE UNIQUE INDEX gene_un ON public."ref-gene" USING btree (description);

CREATE UNIQUE INDEX hospital_un ON public."ref-hospital" USING btree (description);

CREATE UNIQUE INDEX immunophenotype_un ON public."ref-diagnosis" USING btree (description);

CREATE UNIQUE INDEX lineage_un ON public."ref-lineage" USING btree (description);

CREATE UNIQUE INDEX marker_expr_un ON public."ref-expression" USING btree (description);

CREATE UNIQUE INDEX marker_un ON public."ref-marker" USING btree (description);

CREATE UNIQUE INDEX material_origin_un ON public."ref-origin" USING btree (description);

CREATE UNIQUE INDEX medium_un ON public."ref-medium" USING btree (description);

CREATE UNIQUE INDEX plateformat_un ON public."ref-plate_format" USING btree (description);

CREATE UNIQUE INDEX platetype_un ON public."ref-layout_type" USING btree (description);

CREATE UNIQUE INDEX protocol_un ON public."ref-protocol" USING btree (description);

CREATE UNIQUE INDEX readout_un ON public."ref-readout" USING btree (description);

CREATE UNIQUE INDEX ref_approval_status_un ON public."ref-approval_status" USING btree (description);

CREATE UNIQUE INDEX ref_contamination_un ON public."ref-contamination" USING btree (description);

CREATE UNIQUE INDEX ref_country_un ON public."ref-country" USING btree (description);

CREATE UNIQUE INDEX ref_death_cause_un ON public."ref-death_cause" USING btree (description);

CREATE UNIQUE INDEX ref_fitmodel_un ON public."ref-fitmodel" USING btree (description);

CREATE UNIQUE INDEX ref_localization_un ON public."ref-localization" USING btree (description);

CREATE UNIQUE INDEX ref_marker_category_un ON public."ref-marker_category" USING btree (description);

CREATE UNIQUE INDEX ref_msc_detachment_un ON public."ref-msc_detachment" USING btree (description);

CREATE UNIQUE INDEX ref_organ_un ON public."ref-organ" USING btree (description);

CREATE UNIQUE INDEX ref_reader_function_un ON public."ref-reader_function" USING btree (description);

CREATE UNIQUE INDEX ref_resolution_un ON public."ref-resolution" USING btree (description);

CREATE UNIQUE INDEX ref_risk_un ON public."ref-risk" USING btree (description);

CREATE UNIQUE INDEX ref_target_un ON public."ref-target" USING btree (description);

CREATE UNIQUE INDEX response_assessement_id_un ON public."ref-response_assessment" USING btree (description);

CREATE UNIQUE INDEX response_method_un ON public."ref-response_method" USING btree (description);

CREATE UNIQUE INDEX response_mrd_id_un ON public."ref-response_mrd" USING btree (description);

CREATE UNIQUE INDEX sex_un ON public."ref-sex" USING btree (description);

CREATE UNIQUE INDEX subtype_un ON public."ref-subtype" USING btree (description);

CREATE UNIQUE INDEX time_relapse_un ON public."ref-relapse_time" USING btree (description);

CREATE UNIQUE INDEX tissue_un ON public."ref-tissue" USING btree (description);

CREATE UNIQUE INDEX unit_un ON public."ref-unit" USING btree (description);

ALTER TABLE ONLY public.cohort__assay_sample
    ADD CONSTRAINT cohort__assay_sample_cohort_fk FOREIGN KEY (cohort_id) REFERENCES public.cohort(cohort_id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.cohort_stats
    ADD CONSTRAINT cohort_stats_fk FOREIGN KEY (cohort_id) REFERENCES public.cohort(cohort_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.drc_model
    ADD CONSTRAINT drc_model_fk FOREIGN KEY (plate_id) REFERENCES public.plate(plate_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.drc_prediction
    ADD CONSTRAINT drc_prediction_fk FOREIGN KEY (plate_id) REFERENCES public.plate(plate_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.drug__biological_process
    ADD CONSTRAINT drug__biological_process_drug_fk FOREIGN KEY (drug_id) REFERENCES public.drug(drug_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.drug__functional_class
    ADD CONSTRAINT drug__functional_class_drug_fk FOREIGN KEY (drug_id) REFERENCES public.drug(drug_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.drug__synonym
    ADD CONSTRAINT drug__synonym_drug_fk FOREIGN KEY (drug_id) REFERENCES public.drug(drug_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.stage
    ADD CONSTRAINT event_fk FOREIGN KEY (pid) REFERENCES public.patient(pid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.flow
    ADD CONSTRAINT flow_fk FOREIGN KEY (pid) REFERENCES public.patient(pid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.genetics
    ADD CONSTRAINT genetics_fk_2 FOREIGN KEY (pid) REFERENCES public.patient(pid) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.layout_content
    ADD CONSTRAINT layout_content_fk FOREIGN KEY (layout_id) REFERENCES public.layout(layout_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.measurement_content
    ADD CONSTRAINT measurement_content_fk FOREIGN KEY (measurement_id) REFERENCES public.measurement(measurement_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.normalization_content
    ADD CONSTRAINT normalization_content_fk FOREIGN KEY (measurement_id) REFERENCES public.measurement(measurement_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT parameter_fk FOREIGN KEY (plate_id) REFERENCES public.plate(plate_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.plate
    ADD CONSTRAINT plate_fk_assay FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.plate
    ADD CONSTRAINT plate_fk_layout FOREIGN KEY (layout_id) REFERENCES public.layout(layout_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.plate
    ADD CONSTRAINT plate_fk_measurement FOREIGN KEY (measurement_id) REFERENCES public.measurement(measurement_id) ON UPDATE CASCADE ON DELETE CASCADE;



CREATE VIEW public.reference_view AS
 SELECT 'alteration'::text AS ref,
    "ref-alteration".id,
    "ref-alteration".description
   FROM public."ref-alteration"
UNION ALL
 SELECT 'anticoagulant'::text AS ref,
    "ref-anticoagulant".id,
    "ref-anticoagulant".description
   FROM public."ref-anticoagulant"
UNION ALL
 SELECT 'biological_process'::text AS ref,
    "ref-biological_process".id,
    "ref-biological_process".description
   FROM public."ref-biological_process"
UNION ALL
 SELECT 'cell_isolation'::text AS ref,
    "ref-cell_isolation".id,
    "ref-cell_isolation".description
   FROM public."ref-cell_isolation"
UNION ALL
 SELECT 'cell_isolation'::text AS ref,
    "ref-cell_isolation".id,
    "ref-cell_isolation".description
   FROM public."ref-cell_isolation"
UNION ALL
 SELECT 'chromosomal_aberration'::text AS ref,
    "ref-chromosomal_aberration".id,
    "ref-chromosomal_aberration".description
   FROM public."ref-chromosomal_aberration"
UNION ALL
 SELECT 'contaminated'::text AS ref,
    "ref-contamination".id,
    "ref-contamination".description
   FROM public."ref-contamination"
UNION ALL
 SELECT 'country'::text AS ref,
    "ref-country".id,
    "ref-country".description
   FROM public."ref-country"
UNION ALL
 SELECT 'diagnosis'::text AS ref,
    "ref-diagnosis".id,
    "ref-diagnosis".description
   FROM public."ref-diagnosis"
UNION ALL
 SELECT 'disease_stage'::text AS ref,
    "ref-disease_stage".id,
    "ref-disease_stage".description
   FROM public."ref-disease_stage"
UNION ALL
 SELECT 'drp_hospital'::text AS ref,
    "ref-hospital".id,
    "ref-hospital".description
   FROM public."ref-hospital"
UNION ALL
 SELECT 'egil_fab'::text AS ref,
    "ref-egil_fab".id,
    "ref-egil_fab".description
   FROM public."ref-egil_fab"
UNION ALL
 SELECT 'ethnicity'::text AS ref,
    "ref-ethnicity".id,
    "ref-ethnicity".description
   FROM public."ref-ethnicity"
UNION ALL
 SELECT 'expression'::text AS ref,
    "ref-expression".id,
    "ref-expression".description
   FROM public."ref-expression"
UNION ALL
 SELECT 'fitmodel'::text AS ref,
    "ref-fitmodel".id,
    "ref-fitmodel".description
   FROM public."ref-fitmodel"
UNION ALL
 SELECT 'functional_class'::text AS ref,
    "ref-functional_class".id,
    "ref-functional_class".description
   FROM public."ref-functional_class"
UNION ALL
 SELECT 'gene'::text AS ref,
    "ref-gene".id,
    "ref-gene".description
   FROM public."ref-gene"
UNION ALL
 SELECT 'layout_type'::text AS ref,
    "ref-layout_type".id,
    "ref-layout_type".description
   FROM public."ref-layout_type"
UNION ALL
 SELECT 'lineage'::text AS ref,
    "ref-lineage".id,
    "ref-lineage".description
   FROM public."ref-lineage"
UNION ALL
 SELECT 'localization'::text AS ref,
    "ref-localization".id,
    "ref-localization".description
   FROM public."ref-localization"
UNION ALL
 SELECT 'marker'::text AS ref,
    "ref-marker".id,
    "ref-marker".description
   FROM public."ref-marker"
UNION ALL
 SELECT 'marker_category'::text AS ref,
    "ref-marker_category".id,
    "ref-marker_category".description
   FROM public."ref-marker_category"
UNION ALL
 SELECT 'medium'::text AS ref,
    "ref-medium".id,
    "ref-medium".description
   FROM public."ref-medium"
UNION ALL
 SELECT 'msc_detached'::text AS ref,
    "ref-msc_detachment".id,
    "ref-msc_detachment".description
   FROM public."ref-msc_detachment"
UNION ALL
 SELECT 'origin'::text AS ref,
    "ref-origin".id,
    "ref-origin".description
   FROM public."ref-origin"
UNION ALL
 SELECT 'plate_format'::text AS ref,
    "ref-plate_format".id,
    "ref-plate_format".description
   FROM public."ref-plate_format"
UNION ALL
 SELECT 'readout'::text AS ref,
    "ref-readout".id,
    "ref-readout".description
   FROM public."ref-readout"
UNION ALL
 SELECT 'response_assessment'::text AS ref,
    "ref-response_assessment".id,
    "ref-response_assessment".description
   FROM public."ref-response_assessment"
UNION ALL
 SELECT 'response_method'::text AS ref,
    "ref-response_method".id,
    "ref-response_method".description
   FROM public."ref-response_method"
UNION ALL
 SELECT 'response_mrd'::text AS ref,
    "ref-response_mrd".id,
    "ref-response_mrd".description
   FROM public."ref-response_mrd"
UNION ALL
 SELECT 'risk'::text AS ref,
    "ref-risk".id,
    "ref-risk".description
   FROM public."ref-risk"
UNION ALL
 SELECT 'sending_hospital'::text AS ref,
    "ref-hospital".id,
    "ref-hospital".description
   FROM public."ref-hospital"
UNION ALL
 SELECT 'sex'::text AS ref,
    "ref-sex".id,
    "ref-sex".description
   FROM public."ref-sex"
UNION ALL
 SELECT 'subtype'::text AS ref,
    "ref-subtype".id,
    "ref-subtype".description
   FROM public."ref-subtype"
UNION ALL
 SELECT 'relapse_time'::text AS ref,
    "ref-relapse_time".id,
    "ref-relapse_time".description
   FROM public."ref-relapse_time"
UNION ALL
 SELECT 'tissue'::text AS ref,
    "ref-tissue".id,
    "ref-tissue".description
   FROM public."ref-tissue"
UNION ALL
 SELECT 'unit'::text AS ref,
    "ref-unit".id,
    "ref-unit".description
   FROM public."ref-unit"
UNION ALL
 SELECT 'treating_hospital'::text AS ref,
    "ref-hospital".id,
    "ref-hospital".description
   FROM public."ref-hospital";


CREATE OR REPLACE VIEW public.drug_view AS
 SELECT d.drug_id,
    d.drug_name,
    d.kispi_id,
    (COALESCE(NULLIF((d.abbreviation)::text, ''::text), (d.drug_name)::text))::character varying AS abbreviation,
    string_agg(DISTINCT (ds.synonym)::text, ', '::text ORDER BY (ds.synonym)::text) AS synonyms,
    d.min_assay_conc,
    d.max_assay_conc,
    d.unit_id,
    u.description AS unit,
    string_agg(DISTINCT ((fcv.functional_class_id)::character varying)::text, ', '::text) AS functional_classes_id,
    string_agg(DISTINCT (fcv.functional_class)::text, ', '::text ORDER BY (fcv.functional_class)::text) AS functional_classes,
    string_agg(DISTINCT ((bpv.biological_process_id)::character varying)::text, ', '::text) AS biological_processes_id,
    string_agg(DISTINCT (bpv.biological_process)::text, ', '::text ORDER BY (bpv.biological_process)::text) AS biological_processes,
    d.n_doses,
    d.stock_conc,
    d.max_master_conc,
    d.stock_plate_no,
    d.stock_well,
    d.replicates,
    d.plate_priority,
    d.priority,
    d.solvent_id,
    s.description AS solvent,
    d.cas_number
   FROM (((((public.drug d
     LEFT JOIN public."ref-unit" u ON ((d.unit_id = u.id)))
     LEFT JOIN public."ref-solvent" s ON ((d.solvent_id = s.id)))
     LEFT JOIN public.drug__synonym ds ON ((d.drug_id = ds.drug_id)))
     LEFT JOIN public.functional_class_view fcv ON ((d.drug_id = fcv.drug_id)))
     LEFT JOIN public.biological_process_view bpv ON ((d.drug_id = bpv.drug_id)))
  GROUP BY d.drug_id, u.description, s.description;