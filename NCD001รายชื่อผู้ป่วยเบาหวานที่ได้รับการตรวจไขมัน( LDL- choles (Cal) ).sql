--รายชื่อผู้ป่วยDMรพ ที่ตรวจ LDL- choles (Cal)
select distinct t_visit.visit_vn as vn,
t_patient.patient_hn as hn,
f_patient_prefix.patient_prefix_description|| ' ' || t_patient.patient_firstname || ' ' || t_patient.patient_lastname as  "ชื่อ-สกุล",
t_result_lab.result_lab_name as รายการตรวจ,
t_result_lab.result_lab_value as ผลLab,
b_ncd_group.ncd_group_description as กลุ่มNCD
from t_visit 
inner join t_patient on  t_visit.t_patient_id = t_patient.t_patient_id
INNER JOIN t_patient_ncd  on t_patient_ncd.t_patient_id=t_patient.t_patient_id
INNER JOIN b_ncd_group on b_ncd_group.b_ncd_group_id=t_patient_ncd.b_ncd_group_id
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join t_result_lab on t_visit.t_visit_id = t_result_lab.t_visit_id and t_result_lab.result_lab_value <> ''
inner join t_order on t_visit.t_visit_id = t_order.t_visit_id
--inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
where  t_visit.f_visit_status_id <> '4'
and b_ncd_group.b_ncd_group_id='289113542235064925'--25_0.DMรพ
and t_order.f_order_status_id = '4'
and t_result_lab.result_lab_name ilike '%LDL- choles (Cal)%'
--and  substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
and  substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) and substring('2559-09-30',1,10)