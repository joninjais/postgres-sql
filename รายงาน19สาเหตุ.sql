SELECT  r_accident_group.accident_group_description AS accident_group
,case when (sum(query1.male)  > 0 ) then (sum(query1.male))  else 0 end AS male
,case when (sum(query1.female) > 0) then (sum(query1.female)) else 0  end AS female
,case when (sum(query1.nonspecify) > 0) then (sum(query1.nonspecify) )else 0 end AS non_specify
,case when (sum(query1.all) > 0) then (sum(query1.all)) else 0  end AS sumary
,case when (sum(query1.male_inprovince) > 0) then (sum(query1.male_inprovince)) else 0 end AS male_inprovince
,case when (sum(query1.female_inprovince) > 0) then (sum(query1.female_inprovince) ) else 0 end AS female_inprovince
,case when (sum(query1.nonspecify_inprovince) > 0) then (sum(query1.nonspecify_inprovince)) else 0 end AS  non_specify_inprovince
,case when (sum(query1.all_inprovince) > 0) then (sum(query1.all_inprovince) ) else 0 end AS sumary_inprovince
,case when (sum(query1.male_outprovince) > 0) then (sum(query1.male_outprovince)) else 0 end AS  male_outprovince
,case when (sum(query1.female_outprovince)> 0) then (sum(query1.female_outprovince) ) else 0 end AS female_outprovince
,case when (sum(query1.nonspecify_outprovince) > 0) then (sum(query1.nonspecify_outprovince) ) else 0 end AS  non_specify_outprovince
,case when (sum(query1.all_outprovince) > 0 ) then (sum(query1.all_outprovince) ) else 0 end AS sumary_outprovince
,case when (sum(query1.male_death) > 0) then (sum(query1.male_death) ) else 0 end AS male_death
,case when (sum(query1.female_death) > 0) then (sum(query1.female_death) ) else 0 end AS female_death
,case when (sum(query1.nonspecify_death) > 0) then (sum(query1.nonspecify_death) ) else 0 end AS non_specify_death
,case when (sum(query1.all_death) > 0) then (sum(query1.all_death)) else 0 end AS sumary_death
FROM r_accident_group  LEFT JOIN (SELECT distinct t_visit.visit_vn,r_accident_group_code.r_accident_group_id AS r_accident_group_id
,(CASE WHEN (t_patient.f_sex_id = '1') THEN 1 ELSE 0 END) AS male
,(CASE WHEN (t_patient.f_sex_id = '2') THEN 1 ELSE 0 END) AS female
,(CASE WHEN ((t_patient.f_sex_id <> '2' ) AND (t_patient.f_sex_id <> '1' )) THEN 1 ELSE 0 END) AS nonspecify
, (1) AS all
,(CASE WHEN ((t_patient.f_sex_id = '1') AND (t_patient.patient_changwat IN (SELECT b_site.site_changwat FROM b_site))) THEN 1 ELSE 0 END)  AS male_inprovince
,(CASE  WHEN ((t_patient.f_sex_id = '2') AND (t_patient.patient_changwat IN (SELECT b_site.site_changwat FROM b_site))) THEN  1  ELSE 0  END)
AS female_inprovince  ,(CASE  WHEN ((((t_patient.f_sex_id <> '2' ) AND (t_patient.f_sex_id <> '1' )))  AND (t_patient.patient_changwat IN (SELECT b_site.site_changwat FROM b_site)))  THEN  1  ELSE 0  END)  AS  nonspecify_inprovince
,(CASE WHEN (t_patient.patient_changwat IN (SELECT b_site.site_changwat FROM b_site)) THEN  1  ELSE 0  END)  AS all_inprovince
,(CASE  WHEN ((t_patient.f_sex_id = '1') AND (t_patient.patient_changwat NOT IN (SELECT b_site.site_changwat FROM b_site)))  THEN  1  ELSE 0  END)  AS male_outprovince
,(CASE  WHEN ((t_patient.f_sex_id = '2') AND (t_patient.patient_changwat NOT IN (SELECT b_site.site_changwat FROM b_site)))  THEN  1  ELSE 0  END)  AS female_outprovince
,(CASE  WHEN (((t_patient.f_sex_id <> '2' ) AND (t_patient.f_sex_id <> '1' )) AND (t_patient.patient_changwat NOT IN (SELECT b_site.site_changwat FROM b_site)))  THEN  1  ELSE 0  END)  AS  nonspecify_outprovince
,(CASE  WHEN (t_patient.patient_changwat NOT IN (SELECT b_site.site_changwat FROM b_site))  THEN  1  ELSE 0  END)  AS all_outprovince
,(CASE  WHEN ((t_patient.f_sex_id = '1') AND   ((t_visit.f_visit_opd_discharge_status_id = '55')  OR (t_visit.f_visit_opd_discharge_status_id = '52')))  THEN  1  ELSE 0   END)  AS male_death
,(CASE  WHEN ((t_patient.f_sex_id = '2') AND   ((t_visit.f_visit_opd_discharge_status_id = '55')  OR (t_visit.f_visit_opd_discharge_status_id = '52')   ))  THEN  1  ELSE 0  END)  AS female_death
,(CASE  WHEN ((t_patient.f_sex_id <> '2' ) AND (t_patient.f_sex_id <> '1' )  AND   ((t_visit.f_visit_opd_discharge_status_id = '55')  OR (t_visit.f_visit_opd_discharge_status_id = '52')  ))  THEN  1  ELSE 0  END)  AS  nonspecify_death
,(CASE  WHEN ((t_visit.f_visit_opd_discharge_status_id = '55') OR (t_visit.f_visit_opd_discharge_status_id = '52') ) THEN  1  ELSE 0  END)  AS  all_death FROM  r_accident_group_code
, (t_patient INNER JOIN (t_visit INNER JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND ( t_visit.f_visit_status_id <> '4') AND (t_visit.f_visit_type_id = '0') AND (t_diag_icd10.diag_icd10_active ='1')) ON t_patient.t_patient_id = t_visit.t_patient_id)
--WHERE (((substring(t_visit.visit_financial_discharge_time,1,10)) Between $P{start_date} And $P{end_date})
WHERE (((substring(t_visit.visit_financial_discharge_time,1,10)) Between '2559-07-01' And '2559-07-12')
 AND (( t_diag_icd10.diag_icd10_number) Between r_accident_group_code.accident_group_code_begin And r_accident_group_code.accident_group_code_end))
GROUP BY r_accident_group_code.r_accident_group_id ,t_visit.visit_vn ,t_patient.f_sex_id ,t_patient.patient_changwat ,t_visit.f_visit_opd_discharge_status_id
ORDER BY  r_accident_group_id) AS query1  ON r_accident_group.r_accident_group_id = query1.r_accident_group_id
GROUP BY  accident_group