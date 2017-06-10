-- OPD065_1รายชื่อผู้ป่วย DM และ HT ที่ตรวจeGFR-ckd
SELECT  distinct t_patient.patient_hn as Hn

	,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '  ' || t_patient.patient_lastname AS ชื่อผู้ป่วย
--     ,t_visit.visit_patient_age AS อายุ
     ,date_part('year',age(cast(current_date as date)        
  ,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
    ,t_patient.patient_house as บ้านเลขที่
     ,  t_patient.patient_moo as หมู่
    ,   f1.address_description as ตำบล
     ,  f2.address_description as อำเภอ
     ,  f3.address_description as จังหวัด
	--, t_diag_icd10.diag_icd10_number AS ICD10
 ,array_to_string(array_agg(DISTINCT t_diag_icd10.diag_icd10_number),' , ') AS ICD10
  --,(case when trim(t_result_lab.result_lab_name) like '%eGFR-ckd%'  then result_lab_value else '' end) as eGFR
   --  , t_visit.visit_begin_visit_time  AS วันรับบริการ
 ,array_to_string(array_agg(DISTINCT (case when trim(t_result_lab.result_lab_name) like '%eGFR-ckd%'  then result_lab_value else '' end)),' , ') AS eGFR
   --,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
 FROM t_patient
        --- ที่อยู่   
        inner join f_address as f1 on t_patient.patient_tambon = f1.f_address_id
        inner join f_address as f2 on t_patient.patient_amphur = f2.f_address_id
        inner join f_address as f3 on t_patient.patient_changwat = f3.f_address_id
        INNER JOIN t_visit ON t_patient.t_patient_id = t_visit.t_patient_id
        INNER JOIN t_order ON (t_visit.t_visit_id = t_order.t_visit_id and f_order_status_id <> '3' )
        inner join t_diag_icd10 on t_diag_icd10.diag_icd10_vn = t_visit.t_visit_id

              inner JOIN t_result_lab ON (t_order.t_order_id = t_result_lab.t_order_id and t_result_lab.result_lab_value <> '' and t_result_lab.result_lab_active ='1'
                  AND (trim(t_result_lab.result_lab_name) like '%eGFR-ckd%' ))        
          LEFT JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
WHERE 
substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-10-01',1,10) and substring('2559-12-31',1,10)
-- substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
 --substring(t_visit.visit_begin_visit_time,1,10) between substring('2557-10-01',1,10) and substring('2558-09-30',1,10) 
  and t_result_lab.b_item_id='113540274177945'
	and t_patient.f_patient_race_id='99'
        and t_visit.f_visit_status_id <> '4'
	and ((t_diag_icd10.diag_icd10_number between 'E10.1' and 'E11.9' )
	or  t_diag_icd10.diag_icd10_number ='I10' )       
 --   and (t_order.order_common_name like '%eGFR-ckd%' )
GROUP BY
 Hn,  ชื่อผู้ป่วย , บ้านเลขที่ , หมู่ , ตำบล , อำเภอ , จังหวัด   , อายุ 
 
ORDER BY ชื่อผู้ป่วย