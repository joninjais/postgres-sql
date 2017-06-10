--รายการนัดผู้ป่วยDM
select DISTINCT t_patient.patient_hn as HN,
f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล,
t_patient.patient_pid AS เลขบัตรประชาชน,
t_patient.patient_phone_number as เบอร์โทรศัพท์,
 t_patient_appointment.patient_appointment_date as วันนัด,
b_service_point.service_point_description as จุดบริการ,
t_patient.patient_house as บ้านเลขที่,
f1.address_description AS ตำบล, 
f2.address_description AS อำเภอ,
f_appointment_status.appointment_status_name as สถานะการนัด
from t_patient 
inner join t_visit on t_visit.t_patient_id = t_patient.t_patient_id 
inner join t_diag_icd10 as icd101 on icd101.diag_icd10_vn = t_visit.t_visit_id 
                  and (icd101.diag_icd10_number between 'E10' and 'E14'
and icd101.f_diag_icd10_type_id ='1')
inner join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join t_patient_appointment on t_patient.t_patient_id = t_patient_appointment.t_patient_id
inner join f_appointment_status on t_patient_appointment.patient_appointment_status = f_appointment_status.f_appointment_status_id
inner join b_employee on t_patient_appointment.patient_appointment_doctor = b_employee.b_employee_id
inner join b_service_point on b_employee.b_service_point_id = b_service_point.b_service_point_id
LEFT JOIN f_address as f1 ON t_patient.patient_tambon = f1.f_address_id
        LEFT JOIN f_address as f2 ON t_patient.patient_amphur = f2.f_address_id  
        LEFT JOIN f_address as f3 ON t_patient.patient_changwat = f3.f_address_id 
where t_visit.f_visit_status_id <> '4'  --ผู้ป่วยที่ไม่ถูกยกเลิกการเข้ารับบริการ
and t_patient_appointment.patient_appointment_active ='1'
and  substring(t_patient_appointment.patient_appointment_date ,1,10) between substring('2559-11-01',1,10) and substring('2560-02-28',1,10) 
--and  substring(t_patient_appointment.patient_appointment_date ,1,10) between substring(?,1,10) and substring(?,1,10) 

ORDER BY วันนัด
