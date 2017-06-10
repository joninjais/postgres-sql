select distinct(t_visit.visit_vn) as vn
,' ' as กองทุน
,t_patient.patient_hn as hn
,substring(t_visit.visit_begin_visit_time,1,10) as dvisit

,case when (t_patient.f_patient_prefix_id = '001') then 'ดช.'
   when (t_patient.f_patient_prefix_id = '002') then 'ดญ.'
   else ' ' end as pre
,t_patient.patient_firstname as fname
,t_patient.patient_pid as pid
,t_visit.visit_patient_age as age 
,b_contract_plans.contract_plans_description as plans 
,t_order.order_common_name as p_order
,concat_icd10_2(t_visit.t_visit_id,'1')||concat_icd10_2(t_visit.t_visit_id,'2') as icd
,t_billing.billing_total as bill 
from t_visit 
left join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
left join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
left join t_order on t_visit.t_visit_id = t_order.t_visit_id
left join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id
left join t_visit_payment on t_visit.t_visit_id = t_visit_payment.t_visit_id
left JOIN b_contract_plans on t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
inner join t_billing on t_visit.t_visit_id = t_billing.t_visit_id
where t_visit.f_visit_status_id <> '4'
and b_contract_plans.b_contract_plans_id in ('2120000000039','212113547107760953','212000002594847647','212113540938711809')
and t_visit_service.b_service_point_id = '240113548842489811'--pcu
--and t_order.f_item_group_id = '1'
and substring(t_visit.visit_begin_visit_time,1,10) between '2559-05-01' and '2559-06-31'
--AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
ORDER BY t_visit.visit_vn