--รายชื่อผู้ป่วยDMรพ วัดรอบเอว
select distinct 
t_patient.patient_hn as hn
,t_visit.visit_vn as vn
,f_patient_prefix.patient_prefix_description|| ' ' || t_patient.patient_firstname || ' ' || t_patient.patient_lastname as  "ชื่อ-สกุล"
,t_visit_vital_sign.visit_vital_sign_height as ความสูง
,t_visit_vital_sign.visit_vital_sign_waistline_inch as รอบเอว
,b_ncd_group.ncd_group_description as กลุ่มNCD
from t_visit 
inner join t_patient on  t_visit.t_patient_id = t_patient.t_patient_id
INNER JOIN t_patient_ncd  on t_patient_ncd.t_patient_id=t_patient.t_patient_id
INNER JOIN b_ncd_group on b_ncd_group.b_ncd_group_id=t_patient_ncd.b_ncd_group_id
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join t_order on t_visit.t_visit_id = t_order.t_visit_id
LEFT join t_visit_vital_sign on t_visit_vital_sign.t_visit_id=t_visit.t_visit_id
join 
(
SELECT t_visit_id,max(record_time) as maxdate FROM t_visit_vital_sign
GROUP BY t_visit_id
) bip on bip.t_visit_id=t_visit.t_visit_id and bip.maxdate=t_visit_vital_sign.record_time
--inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
where  t_visit.f_visit_status_id <> '4'
and b_ncd_group.b_ncd_group_id='289113542235064925'--25_0.DMรพ
and t_order.f_order_status_id = '4'
and t_visit_vital_sign.visit_vital_sign_waistline_inch <> ''
--and  substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
and  substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) and substring('2559-09-30',1,10)