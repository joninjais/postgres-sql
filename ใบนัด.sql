select 
 b_site.site_full_name as site_full_name
,b_site.site_phone_number as site_phone_number

,f_patient_prefix.patient_prefix_description as prefix_patient
,t_patient.patient_firstname as firstname
,t_patient.patient_lastname as lastname
,f_sex.sex_description as sex
,t_patient.patient_hn as hn
,t_patient.patient_house as house
,t_patient.patient_moo as moo
,t_patient.patient_road as road
,changwat.address_description as province
,amphur.address_description as amphur
,tambon.address_description as tambon

,t_visit.visit_patient_age as patient_age
,t_visit.visit_vn as an
----------------------------------------------------------------------------------
--///////////////////////
,b_employee.employee_firstname || ' ' || b_employee.employee_lastname as appointment_staff
,doctor.employee_firstname || ' ' || doctor.employee_lastname as doctor
,b_service_point.service_point_description as service_point
,t_patient_appointment.patient_appointment_date as appointment_date
,t_patient_appointment.patient_appointment_time as appointment_time
,t_patient_appointment.patient_appointment as topic
,t_patient_appointment.patient_appointment_notice as appointment_notice
,t_patient_appointment_order.patient_appointment_order_common_name as order_common_name
 from t_patient_appointment 
--///////////////////////
 ----------------------------------------------------------------------------------
left join t_visit on t_patient_appointment.t_visit_id = t_visit.t_visit_id
left join t_patient on t_patient_appointment.t_patient_id = t_patient.t_patient_id
left join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
left join f_sex on t_patient.f_sex_id = f_sex.f_sex_id
left join (select * from f_address) as changwat on changwat.f_address_id = t_patient.patient_changwat
left join (select * from f_address) as amphur on amphur.f_address_id = t_patient.patient_amphur
left join (select * from f_address) as tambon on tambon.f_address_id = t_patient.patient_tambon

----------------------------------------------------------------------------------
--///////////////////////
left join b_employee on t_patient_appointment.patient_appointment_staff = b_employee.b_employee_id
left join (select * from b_employee) as doctor on t_patient_appointment.patient_appointment_doctor = doctor.b_employee_id
--left join b_service_point on b_service_point.b_service_point_id = t_patient_appointment.patient_appointment_clinic
left join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id
left join b_service_point on b_service_point.b_service_point_id = t_visit_service.b_service_point_id
left join t_patient_appointment_order on t_patient_appointment_order.t_patient_appointment_id = t_patient_appointment.t_patient_appointment_id
cross join b_site
where t_patient_appointment.t_patient_appointment_id =  '110113547736602685'--$P{appointment_id}
and t_visit_service.visit_service_staff_doctor<>''

