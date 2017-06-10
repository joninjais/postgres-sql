--manage024 รายชื่อผู้ป่วยชำระเงินรายคน
SELECT distinct
		t_visit.visit_begin_visit_time AS วันรับบริการ
    ,t_visit.visit_hn AS HN
		,t_visit.visit_vn
    ,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
		,b_contract_plans.contract_plans_description AS สิทธ
		,t_billing_receipt.billing_receipt_paid AS ผู้ป่วยจ่าย
		,t_billing.billing_payer_share AS สิทธิชำระ
		,t_billing.billing_remain AS ค้างชำระ
		,t_billing.billing_total AS ยอดรวม
--		,t_billing_invoice.billing_invoice_patient_share
 FROM t_visit
inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join t_billing ON t_billing.t_visit_id=t_visit.t_visit_id
inner join t_billing_receipt ON t_billing_receipt.t_visit_id=t_visit.t_visit_id
inner join t_billing_invoice ON t_billing_invoice.t_visit_id=t_visit.t_visit_id
inner join t_visit_payment ON t_visit_payment.t_visit_id=t_visit.t_visit_id
inner join b_contract_plans ON b_contract_plans.b_contract_plans_id=t_visit_payment.b_contract_plans_id
where t_visit.f_visit_status_id = '3'		--จบกระบวนการ
AND t_billing.billing_active = '1'
AND t_billing_invoice.billing_invoice_active = '1' --รายการแจ้งหนี้  
AND	t_billing_receipt.billing_receipt_active = '1' --รายการรับชำระ สถานะของการรับชำระ 	
AND t_visit_payment.visit_payment_active = '1'	--สิทธิการรักษาแต่ละครั้ง 
and t_visit_payment.visit_payment_priority = '0' 
	and substring(t_visit.visit_begin_visit_time,1,10) between substring('2560-03-07',1,10) AND substring('2560-03-07',1,10)
--            and substring(t_visit.visit_begin_visit_time,1,10) between substring (?,1,10) and substring(?,1 ,10)
--	and t_visit.visit_begin_visit_time between '2558-08-25,14:00' AND '2558-08-26,15:00'
--	and t_visit.visit_begin_visit_time between ? AND ? 
ORDER BY t_visit.visit_begin_visit_time

