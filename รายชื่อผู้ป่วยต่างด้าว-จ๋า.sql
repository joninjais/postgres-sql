SELECT
'จำนวนต่างด้าว IPD' as รายการ
,count(distinct q1.hn) as คน  
,count(q1.vn) as ครั้ง 
FROM
(select distinct(t_visit.visit_vn) as vn

,t_patient.patient_hn as hn
,substring(t_visit.visit_begin_visit_time,1,10) as dvisit
,f_patient_prefix.patient_prefix_description as pre
,t_patient.patient_firstname as fname
,t_patient.patient_pid as pid
,t_visit.visit_patient_age as age 
,b_contract_plans.contract_plans_description as plans 
--,t_visit.f_visit_type_id as ptype

from t_visit 
left join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
left join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
left join t_order on t_visit.t_visit_id = t_order.t_visit_id
left join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id
left join t_visit_payment on t_visit.t_visit_id = t_visit_payment.t_visit_id
left JOIN b_contract_plans on t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
where t_visit.f_visit_status_id <> '4'
and b_contract_plans.b_contract_plans_id in ('2120000000039','212113547107760953','212000002594847647')
--and t_visit_service.b_service_point_id = '2060761082126'--opd
and t_visit.f_visit_type_id='1'
--and t_order.f_item_group_id = '1'
and substring(t_visit.visit_begin_visit_time,1,10) between '2557-10-01' and '2558-09-30'
--AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
ORDER BY t_visit.visit_vn ) as q1