--stat008รายชื่อผู้ป่วยเสียชีวิต
select   distinct patient_hn AS HN
,visit_vn as หมายเลขVN
,t_patient.patient_firstname || '  ' || t_patient.patient_lastname AS ชื่อผู้ป่วย
,t_visit.visit_patient_age as อายุ
    , case when t_visit.f_visit_type_id = '1'   then 'IPD'
               when t_visit.f_visit_type_id = '0'   then 'OPD'
      else ''
      end AS ประเภท
,'เลขที่'||' '|| t_patient.patient_house as บ้านเลขที่
,'หมู่ที่'||' '|| t_patient.patient_moo as หมู่
 ,'บ้าน'||' '|| t_health_village.village_name as ชื่อหมู่บ้าน
,f_address1.address_description as ตำบล
,f_address2.address_description as อำเภอ
,f_address3.address_description as จังหวัด
,substring(t_death.death_date_time,1,16) AS death_times
,t_visit.visit_dx as Dx
,t_diag_icd10.diag_icd10_number as ICD10
,death_cause as สาเหตุที่ตาย
,death_place_type_description as สถานที่เสียชีวิต
from t_death  
inner join t_visit on t_visit.t_visit_id = t_death.t_visit_id
inner join t_patient on t_patient.t_patient_id = t_visit.t_patient_id
inner join f_patient_prefix on f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id
inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn and t_diag_icd10.f_diag_icd10_type_id ='1'
LEFT JOIN f_address AS f_address1 ON f_address1.f_address_id = t_patient.patient_tambon 
LEFT JOIN f_address AS f_address2 ON f_address2.f_address_id = t_patient.patient_amphur 
LEFT JOIN f_address AS f_address3 ON f_address3.f_address_id = t_patient.patient_changwat
INNER JOIN t_health_family on t_patient.t_health_family_id = t_health_family.t_health_family_id 
INNER JOIN t_health_home ON (t_health_family.t_health_home_id = t_health_home.t_health_home_id)
INNER JOIN t_health_village ON (t_health_home.t_health_village_id = t_health_village.t_health_village_id)
left join f_death_place_type on t_death.death_site = f_death_place_type.f_death_place_type_id
where 
       t_death.death_active ='1' 
AND t_health_family.health_family_active = '1'
--and f_visit_type_id = '0' -- 0 คือผู้ป่วยนอก ,1 คือผู้ป่วยใน
--AND  f_address1.address_description like '%โคกกลอย%'
--AND t_health_village.village_moo in ('1','01','2','02','4','04','6','06','9','09','10','12','13')
--and substring(t_visit.visit_begin_visit_time,1,10) between  '2557-04-01' and '2558-04-30'
and substring(t_visit.visit_financial_discharge_time   ,1,16)  Between substring('2559-01-01',1,10) AND substring('2560-01-31',1,10)  
--and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)




