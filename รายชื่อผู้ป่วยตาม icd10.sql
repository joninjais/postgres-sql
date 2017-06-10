select 
	 t_visit.visit_begin_visit_time AS วันรับบริการ
    ,t_visit.visit_hn  as HN
    ,t_visit.visit_vn AS VN
    ,t_patient.patient_pid AS PID
    ,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
    ,t_visit.visit_patient_age AS อายุ
    --,t_diag_icd10.diag_icd10_number as icd10
    ,array_to_string(array_agg(DISTINCT t_diag_icd10.diag_icd10_number),' , ') AS icd10
    ,b_contract_plans.contract_plans_description as สิทธิการรักษา
    ,sum(t_billing_invoice.billing_invoice_total) AS ค่ารักษาinvoice
from 
	t_visit inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
    inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
	inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
 inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id --and t_visit_service.b_service_point_id ='2402024154365'--12.แพทย์แผนไทย
  LEFT JOIN t_visit_payment ON t_visit.t_visit_id = t_visit_payment.t_visit_id 
                                        AND t_visit_payment.visit_payment_priority ='0' AND t_visit_payment.visit_payment_active ='1'
LEFT JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id 
 LEFT JOIN t_billing_invoice ON t_billing_invoice.t_visit_id = t_visit_payment.t_visit_id AND t_billing_invoice.billing_invoice_active ='1'
where 
 t_visit.f_visit_status_id <> '4'		
and t_diag_icd10.diag_icd10_number like 'M17%'		
--and t_diag_icd10.diag_icd10_number like 'U%'
and t_visit.visit_patient_age > '60'		 
and substring(t_visit.visit_begin_visit_time,1,10) between substring ('2559-10-01',1,10) and substring('2560-03-28',1 ,10)
--and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)	
GROUP by วันรับบริการ, HN,VN,PID,ชื่อสกุล, อายุ,สิทธิการรักษา
ORDER BY วันรับบริการ