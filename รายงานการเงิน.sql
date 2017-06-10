select
count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='0' and b_contract_plans.contract_plans_pttype in ('AJ','UC','AB','AD','AE') ) 
then t_visit.t_visit_id
else null
end) as a11

, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='0' and b_contract_plans.contract_plans_pttype in ('A7') ) 
then t_visit.t_visit_id
else null
end) as a12
, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='0' and b_contract_plans.contract_plans_pttype in ('A2') ) 
then t_visit.t_visit_id
else null
end) as a13
, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='0' and b_contract_plans.contract_plans_pttype in ('LG') ) 
then t_visit.t_visit_id
else null
end) as a14
, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='0' ) 
then t_visit.t_visit_id
else null
end) as a15
, count(distinct case when (t_visit.t_patient_id <> '' and t_visit.t_patient_id is not null 
and t_visit.f_visit_type_id ='0' ) 
then t_visit.t_patient_id
else null
end) as a16

, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' and b_contract_plans.contract_plans_pttype in ('AJ','UC','AB','AD','AE') ) 
then t_visit.t_visit_id
else null
end) as a21

, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' and b_contract_plans.contract_plans_pttype in ('A7') ) 
then t_visit.t_visit_id
else null
end) as a22
, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' and b_contract_plans.contract_plans_pttype in ('A2') ) 
then t_visit.t_visit_id
else null
end) as a23
, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' and b_contract_plans.contract_plans_pttype in ('LG') ) 
then t_visit.t_visit_id
else null
end) as a24
, count(distinct case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' ) 
then t_visit.t_visit_id
else null
end) as a25

, sum(case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' ) 
then t_diag_tdrg.wtlos
else null
end) as a31
, sum(case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' and b_contract_plans.contract_plans_pttype in ('AJ','UC','AB','AD','AE') ) 
then t_diag_tdrg.adjrw
else null
end) as a41
, sum(case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' and b_contract_plans.contract_plans_pttype in ('A7') ) 
then t_diag_tdrg.adjrw
else null
end) as a42
, sum(case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' and b_contract_plans.contract_plans_pttype in ('A2') ) 
then t_diag_tdrg.adjrw
else null
end) as a43
, sum(case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1' and b_contract_plans.contract_plans_pttype in ('LGO') ) 
then t_diag_tdrg.adjrw
else null
end) as a44
, sum(case when (t_visit.t_visit_id <> '' and t_visit.t_visit_id is not null 
and t_visit.f_visit_type_id ='1') 
then t_diag_tdrg.adjrw
else null
end) as a45

from t_visit inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
inner join t_visit_payment ON t_visit.t_visit_id = t_visit_payment.t_visit_id
inner join b_contract_plans on b_contract_plans.b_contract_plans_id = t_visit_payment.b_contract_plans_id
left join b_visit_office on b_visit_office.b_visit_office_id = t_visit_payment.visit_payment_main_hospital
left join t_diag_tdrg on t_visit.t_visit_id = t_diag_tdrg.t_visit_id
where t_visit.f_visit_status_id <>'4' 
and t_visit_payment.visit_payment_active = '1'
and t_visit_payment.visit_payment_priority = '0'
and substring(t_visit.visit_begin_visit_time,1,10) BETWEEN '2559-10-01' AND '2559-10-31'