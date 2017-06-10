SELECT 
v.visit_hn AS HN
,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
,d.death_cause as สาเหตุการตาย
,d.death_date_time as วันที่ตาย
,b_employee.employee_firstname||' '||b_employee.employee_lastname as ผู้บันทึก
FROM t_death d
INNER JOIN t_visit v on v.t_visit_id=d.t_visit_id
INNER JOIN t_patient on t_patient.t_patient_id=d.t_patient_id and t_patient.f_sex_id='1' --IPD
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id

LEFT JOIN b_employee on b_employee.b_employee_id=d.death_staff_record
WHERE v.f_visit_opd_discharge_status_id='52'
and  substr(v.visit_begin_visit_time,1,10) between '2557-05-01' and '2559-08-31'
--LIMIT 10