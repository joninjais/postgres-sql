--ผู้ป่วยผ่านจุดบริการ
SELECT 
 distinct t_patient.patient_hn  AS HN_NUMBER
 ,t_visit.visit_vn AS VN_AN_NUMBER
 ,t_patient.patient_pid as PID
 ,f_patient_prefix.patient_prefix_description AS PREFIX
 ,t_patient.patient_firstname AS PATIENT_NAME
 ,t_patient.patient_lastname AS LASTNAME
 ,substr(b_service_point.service_point_description,4) AS NAME_SERVICEPOINT
,t_visit.visit_dx AS DX
 ,t_visit.visit_begin_visit_time as วันที่เข้ารับบริการ

--,substr(visit_financial_discharge_time,12,5)as การเงิน 
 FROM  ((t_visit 
INNER JOIN (t_visit_service 
INNER JOIN b_service_point  ON t_visit_service.b_service_point_id = b_service_point.b_service_point_id)   
ON t_visit.t_visit_id = t_visit_service.t_visit_id) 
INNER JOIN t_patient  ON t_visit.t_patient_id = t_patient.t_patient_id)  
INNER JOIN f_patient_prefix  ON f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id  

WHERE(substr(t_visit.visit_begin_visit_time,1,10) Between '2558-10-01' and '2559-09-30') 
 
--(((substring(assign_date_time,1,16)) Between ? And ?)
AND t_visit.f_visit_type_id ='0'
and t_visit.f_visit_status_id <> '4'  
AND ((b_service_point.b_service_point_id) in ('2060761082126'))--('2068315875716','2409144269314','240113543495662430'))  --เปลี่ยนรหัส เป็นรหัสจุดบริการที่ต้องการ
GROUP BY  b_service_point.service_point_description , t_visit.visit_hn,t_patient.patient_pid,t_patient.patient_hn,t_visit.visit_begin_visit_time
, t_visit.visit_vn , f_patient_prefix.patient_prefix_description , t_patient.patient_firstname , t_patient.patient_lastname 
, b_service_point.b_service_point_id , t_visit_service.visit_service_staff_doctor ,t_visit.visit_financial_discharge_time,dx 
 
order by 
วันที่เข้ารับบริการ
--substr(visit_financial_discharge_time,12,5)