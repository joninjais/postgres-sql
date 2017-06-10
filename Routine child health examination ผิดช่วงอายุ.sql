select 
t_patient.patient_hn AS hn 
,t_visit.visit_vn AS VN
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
   ,t_patient.patient_lastname AS สกุล
    ,t_visit.visit_patient_age AS อายุ
    ,t_visit.visit_begin_visit_time AS วันรับบริการ
--    ,b_service_point.service_point_description AS จุดบริการที่ส่ง
    --,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
,t_visit.visit_dx AS "DXแพทย์"
  ,b_visit_clinic.visit_clinic_description AS ประเภทโรค
--,b_employee.employee_firstname||' '||b_employee.employee_lastname as ผู้บันทึก
from t_visit 

        inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id AND t_visit.f_visit_status_id <> '4' 
        INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
--        INNER JOIN b_employee ON b_employee.b_employee_id = t_visit_refer_in_out.visit_refer_in_out_staff_refer
--        INNER JOIN b_service_point ON b_service_point.b_service_point_id = b_employee.b_service_point_id
                                                                       
       LEFT JOIN t_diag_icd10 ON t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn AND t_diag_icd10.diag_icd10_active ='1' 
                       AND t_diag_icd10.f_diag_icd10_type_id='1'
       LEFT JOIN b_icd10 ON b_icd10.icd10_number = t_diag_icd10.diag_icd10_number
       LEFT JOIN b_visit_clinic ON t_diag_icd10.b_visit_clinic_id = b_visit_clinic.b_visit_clinic_id
where 
substring(t_visit.visit_begin_visit_time,1,10) between substring('2557-10-01',1,10) AND substring('2560-02-28',1,10)
and (t_visit.visit_patient_age > '14')
and (t_visit.visit_patient_age not in ('1','2','3','4','5','6','7','8','9','10','11','12','13','14') )
and t_visit.visit_dx like 'Routine child health examination'
 ORDER BY t_visit.visit_begin_visit_time
