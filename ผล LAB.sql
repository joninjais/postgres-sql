select
site_full_name as hospital
,visit_type_description as patientType
,patient_prefix_description 
|| '  ' || patient_firstname 
|| '  ' || patient_lastname as name
,visit_patient_age as age
,sex_description as sex
,visit_hn  as hn
,contract_plans_description as plan
,visit_vn as vn
--,substring(visit_begin_visit_time,9,2)||'/' || substring(visit_begin_visit_time,6,2)||'/' || substring(visit_begin_visit_time,1,4) as dateVisit
,substring(visit_begin_visit_time,9,2)||' ' || 
(case
when substring(visit_begin_visit_time,6,2)='01' then 'มกราคม' 
when substring(visit_begin_visit_time,6,2)='02' then 'กุม๓าพันธ์' 
when substring(visit_begin_visit_time,6,2)='03' then 'มีนาคม' 
when substring(visit_begin_visit_time,6,2)='04' then 'เมษายน'  
when substring(visit_begin_visit_time,6,2)='05' then 'พฤษภาคม' 
when substring(visit_begin_visit_time,6,2)='06' then 'มิถุนายน' 
when substring(visit_begin_visit_time,6,2)='07' then 'กรกฎาคม' 
when substring(visit_begin_visit_time,6,2)='08' then 'สิงหาคม' 
when substring(visit_begin_visit_time,6,2)='09' then 'กันยายน' 
when substring(visit_begin_visit_time,6,2)='10' then 'ตุลาคม' 
when substring(visit_begin_visit_time,6,2)='11' then 'พฤศจิกายน' 
when substring(visit_begin_visit_time,6,2)='12' then 'ธันวาคม'  
else null end)
||' ' || substring(visit_begin_visit_time,1,4) ||' ' || substring(visit_begin_visit_time,12,14) as dateVisit
,visit_payment_card_number as Payment_ID
,main.visit_office_name as MainHospital
,sub.visit_office_name as SubHospital
,patient_pid as Pid
,patient_phone_number as TelephoneNumber
,t_order.order_common_name as labGroup
,result_lab_name as lab
,result_lab_value as labResult
,result_lab_unit as unit
,result_lab_min || ' - ' || result_lab_max as normal
,substring(order_date_time,1,10) as dateOrderLab
,substring(order_report_date_time,1,10) as dateResultLab
--,current_date || ' ' || current_time as datePrint
,substring(to_char(current_date, 'ddmmyyyy'),1,2)||' ' || 
(case
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='01' then 'มกราคม' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='02' then 'กุม๓าพันธ์' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='03' then 'มีนาคม' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='04' then 'เมษายน'  
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='05' then 'พฤษภาคม' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='06' then 'มิถุนายน' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='07' then 'กรกฎาคม' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='08' then 'สิงหาคม' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='09' then 'กันยายน' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='10' then 'ตุลาคม' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='11' then 'พฤศจิกายน' 
when substring(to_char(current_date, 'ddmmyyyy'),3,2)='12' then 'ธันวาคม'  
else null end)
||' ' || cast(substring(to_char(current_date, 'ddmmyyyy'),5,6) as int)+543 ||' ' || current_time as datePrint
,current_time as timeprint
,item_common_name as labgroup
,q3.bmi

from t_order 
	inner join t_visit on (t_order.t_visit_id = t_visit.t_visit_id 
		and t_order.f_order_status_id = '4' 
        and t_order.t_visit_id = '255113545473424217')
	inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
	inner join t_result_lab on (t_result_lab.t_order_id = t_order.t_order_id 
		and t_result_lab.result_lab_active = '1')
	inner join b_item on b_item.b_item_id = t_order.b_item_id
	inner join t_visit_payment on (t_visit_payment.t_visit_id = t_visit.t_visit_id
and visit_payment_priority = '0' and visit_payment_active = '1')
LEFT JOIN
(select t_visit_vital_sign.t_visit_id
,visit_vital_sign_height as height
,visit_vital_sign_weight  as weight
,visit_vital_sign_blood_presure as blood_presure
,visit_vital_sign_heart_rate as heart_rate
,visit_vital_sign_bmi as bmi
from t_visit_vital_sign inner join
(select t_visit_id,max(record_time) as time from t_visit_vital_sign
where visit_vital_sign_active = '1' and t_visit_id ='255113545473424217'
group by t_visit_vital_sign.t_visit_id ) as q2
on t_visit_vital_sign.t_visit_id = q2.t_visit_id
and t_visit_vital_sign.record_time = q2.time) as q3
ON t_visit.t_visit_id = q3.t_visit_id
	inner join f_patient_prefix on 
		   t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id 
	inner join b_contract_plans on 
		   b_contract_plans.b_contract_plans_id = t_visit_payment.b_contract_plans_id
	inner join f_sex on f_sex.f_sex_id = t_patient.f_sex_id
	inner join f_visit_type on f_visit_type.f_visit_type_id = t_visit.f_visit_type_id
	inner join (select * from b_visit_office) as main 
		on main.b_visit_office_id = t_visit_payment.visit_payment_main_hospital
	left join (select * from b_visit_office) as sub 
		on sub.b_visit_office_id = t_visit_payment.visit_payment_sub_hospital
	, b_site
order by order_verify_date_time,result_lab_index