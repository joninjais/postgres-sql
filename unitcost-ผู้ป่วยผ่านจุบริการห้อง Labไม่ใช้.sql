select distinct
     t_visit.visit_hn AS HN 
    ,t_visit.visit_vn as vn
    ,f_patient_prefix.patient_prefix_description AS คำนำ
    ,t_patient.patient_firstname AS ชื่อ
    ,t_patient.patient_lastname AS สกุล
    ,t_patient.patient_pid AS PID
    ,t_visit.visit_begin_visit_time as วันรับบริการ
    ,t_visit.visit_financial_discharge_time AS วันจำหน่าย
		,t_visit.f_visit_type_id
FROM       t_patient  
            INNER JOIN t_visit  ON t_patient.t_patient_id = t_visit.t_patient_id
            INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
            INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id                                                       
            inner join  t_billing ON (t_billing.t_visit_id = t_visit.t_visit_id AND t_billing.billing_active = '1')
            inner join  f_patient_prefix ON (f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id AND f_patient_prefix.active ='1')
            inner join t_billing_invoice ON t_billing_invoice.t_visit_id = t_visit_payment.t_visit_id and t_billing_invoice.billing_invoice_active ='1'
            inner join t_order on t_visit.t_visit_id = t_order.t_visit_id
            inner join t_result_lab on t_result_lab.t_order_id = t_order.t_order_id
            inner join b_item on b_item.b_item_id = t_order.b_item_id
            inner join f_item_lab_type on f_item_lab_type.id = b_item.f_item_lab_type_id 

WHERE t_visit.f_visit_status_id <> '4'
            AND   t_visit.f_visit_type_id = '1' --เลือก 1 ผู้ป่วยใน 0 ผู้ป่วยนอก
            AND  t_visit_payment.visit_payment_priority = '0'
            

AND substring(t_visit.visit_begin_visit_time,1,10) BETWEEN substring('2558-10-01',1,10) AND substring('2559-09-30',1,10)