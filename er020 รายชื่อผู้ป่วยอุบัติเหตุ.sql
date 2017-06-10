--er020 รายชื่อผู้ป่วยอุบัติเหตุ
select DISTINCT
t_visit.visit_hn as HN
--,t_visit.t_visit_id
--,t_visit.visit_vn
,f_patient_prefix.patient_prefix_description || ' ' || t_patient.patient_firstname || ' ' || t_patient.patient_lastname as ชื่อสกุล
,t_visit.visit_begin_visit_time as วันที่เข้ารับบริการ
,t_accident.accident_date as วันที่เกิดอุบัติเหตุ
,t_accident.accident_time as เวลาที่เกิดอุบัติเหตุ
,t_accident.accident_road_name as สถานที่เกิดเหตุ
  ,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
,b_employee.employee_firstname || ' ' || b_employee.employee_lastname as ผู้บันทึก
--,t_visit_primary_symptom.visit_primary_symptom_main_symptom AS อาการสำคัญ
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_main_symptom),' , ') AS อาการสำคัญ
from t_patient
inner join t_visit on t_patient.t_patient_id = t_visit.t_patient_id
inner join t_accident on t_visit.t_visit_id = t_accident.t_visit_id
inner join b_employee on b_employee.b_employee_id = t_accident.accident_staff_record
inner join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
--inner join t_visit_primary_symptom on t_visit_primary_symptom.t_patient_id=t_patient.t_patient_id
inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id=t_visit.t_visit_id and t_visit_primary_symptom.visit_primary_symptom_active='1'
where
 SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr('2559-06-01',1,10) and substr('2559-06-15',1,10)
 --SUBSTRING(t_visit.visit_begin_visit_time,1,10) between substr(?,1,10) and substr(?,1,10)
 and t_visit.f_visit_status_id <> '4'
GROUP BY hn,ชื่อสกุล,วันที่เข้ารับบริการ,วันที่เกิดอุบัติเหตุ,เวลาที่เกิดอุบัติเหตุ,สถานที่เกิดเหตุ,ผู้บันทึก,ระดับความรุนแรง
order by t_visit.visit_begin_visit_time