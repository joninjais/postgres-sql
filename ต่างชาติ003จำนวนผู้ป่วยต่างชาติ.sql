SELECT  
'จำนวนผู้ป่วย ' as รายการ  
   ,count(DISTINCT q.visit_hn) as คน
   ,count( q.visit_vn) as ครั้ง
from
(SELECT
 t_visit.visit_hn,
 t_visit.visit_vn,
 t_visit.visit_begin_visit_time,
 t_patient.patient_firstname,
 t_patient.patient_lastname
FROM t_visit
LEFT JOIN t_patient on t_patient.t_patient_id = t_visit.t_patient_id
WHERE t_patient.f_patient_nation_id not in ('46','92','97','250','48','56','57','248','99','249','94','98','95','093','198','199','256','262','84','208','0','90','null')
   AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring('2558-10-01',1,10) and substring('2559-09-30',1,10)
  --AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
) as q