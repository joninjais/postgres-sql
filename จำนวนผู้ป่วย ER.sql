--รายชื่อผู้ป่วยER
select distinct

   count(DISTINCT t_visit.visit_hn) as คน
    ,count(DISTINCT t_visit.visit_vn) AS ครั้ง

from 
	t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
    inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
   inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
	inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
inner join b_icd10 on b_icd10.icd10_number= t_diag_icd10.diag_icd10_number
 inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2409144269314'
where 
	
 t_visit.f_visit_status_id <> '4'					 
	and substring(t_visit.visit_begin_visit_time,1,10) between substring('2555-10-01',1,10) AND substring('2556-09-30',1,10)
--              and substring(t_visit.visit_begin_visit_time,1,10) between substring (?,1,10) and substring(?,1 ,10)
--GROUP BY 	วันรับบริการ , HN , VN ,	ชื่อสกุล , อายุ  , dxแพทย์ 	
--ORDER BY วันรับบริการ
--ORDER BY ชื่อสกุล