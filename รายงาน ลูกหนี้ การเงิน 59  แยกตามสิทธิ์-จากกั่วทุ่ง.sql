-- รายงาน ลูกหนี้ การเงิน 59  แยกตามสิทธิ์
SELECT 
  t_visit.visit_hn as HN
 ,t_visit.visit_vn as VN
 ,f_patient_prefix.patient_prefix_description||''||t_patient.patient_firstname||'  '||t_patient.patient_lastname as "ชื่อ-สกุล"
 ,SUBSTRING( t_visit.visit_begin_visit_time,1,16) as วันที่รับบริการ
 ,b_contract_plans.contract_plans_description AS สิทธิ์การรักษา
 ,t_billing.billing_payer_share as "สิทธิชำระ"
 ,t_billing.billing_patient_share as "ผู้ป่วยชำระ"
 ,t_billing.billing_total as  "รวมทั้งหมด"

--,t_billing.billing_paid as "ผู้ป่วยจ่ายแล้วเท่าไร", t_billing.billing_remain as "ค้างอยู่เท่าไร"
--,b_employee.employee_firstname, b_employee.employee_lastname

FROM t_visit 
INNER JOIN t_patient ON t_visit.visit_hn = t_patient.patient_hn   and  t_visit.f_visit_type_id = '1' -- 0 ผู้ป่วยนอกก  1  ผู้ป่วยใน
INNER JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
INNER JOIN t_visit_payment ON t_visit.t_visit_id = t_visit_payment.t_visit_id 
INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
    /*  and  b_contract_plans.b_contract_plans_id  in ('2120000000007','2120000000014','2120000000020','2120000000025','2120000000042','2120000000051','2120000000055','2120000000060','2120000000066','2120000000073','212113498569057481',
 '212113498943228273','212113490663576509','212113491675961377','2120000000084','212113497079968032','2120000000077','212113495428460763','212113490280797472','212113492164512476','212113499668908199')*/ --group id สิทธิที่ต้องการ

INNER JOIN t_billing ON t_visit.t_visit_id = t_billing.t_visit_id

--INNER JOIN b_employee ON t_billing.billing_staff_record = b_employee.b_employee_id
 
WHERE 
      
--AND  t_billing.billing_remain > 0
     t_visit_payment.visit_payment_priority = '0' -- สิทธิรับบริการ อันดับแรก
and  t_visit_payment.visit_payment_active='1' --สิทธิไม่ถูกยกเลิก
and  t_visit.f_visit_status_id <> '4'
  AND SUBSTRING (t_visit.visit_begin_visit_time,1,10) between  '2558-09-28' and '2558-09-28'
--and substring(t_visit.visit_begin_visit_time,1,16) between ? and ?
ORDER BY วันที่รับบริการ  