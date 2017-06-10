--
SELECT 

count(DISTINCT t_visit.visit_hn) AS คน
,count(DISTINCT t_visit.visit_vn) AS ครั้ง
FROM  
t_visit INNER JOIN  t_patient  ON t_visit.t_patient_id = t_patient.t_patient_id
INNER JOIN t_patient_ncd ON t_patient.t_patient_id = t_patient_ncd.t_patient_id
LEFT JOIN f_patient_prefix  ON f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id 
LEFT JOIN f_address AS f1 ON t_patient.patient_tambon = f1.f_address_id
LEFT JOIN f_address AS f2 ON t_patient.patient_amphur = f2.f_address_id
LEFT JOIN f_address AS f3 ON t_patient.patient_changwat = f3.f_address_id
WHERE
t_visit.f_visit_status_id <> '4' 
and   substring(t_visit.visit_begin_visit_time,1,10)  between  '2555-10-01' and '2556-09-30'

