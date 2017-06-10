select 'จำนวนผู้รับบริการผู้ป่วยนอก' as รายการ
,count(distinct t_visit.t_visit_id) as จำนวนครั้ง
,count(distinct t_visit.visit_hn) as จำนวนคน

from t_visit
left join t_diag_icd10 on t_diag_icd10.diag_icd10_vn = t_visit.t_visit_id
left join b_visit_clinic on b_visit_clinic.b_visit_clinic_id = t_diag_icd10.b_visit_clinic_id
where t_visit.f_visit_type_id ='0' 
and t_visit.f_visit_status_id <> '4'
and substring(t_visit.visit_begin_visit_time,1,10)  between '2555-10-01' and '2556-09-30'