--manage023รายงานรายได้ค่ารักษา-ชำระเงินเอง (ชำระจริง,ค้าง,รวมค่ารักษา) จำแนกสิทธิ
/*  
not in 
2120000000001       เบิกได้ผู้ป่วยนอก
***ได้ยอดแล้วต้องลบรายได้ค่าธรรมเนียมต่างด้าวมีบัตร  จึงจะได้รายได้ค่ารักษาที่ไม่รวมค่าธรรมเนียม****
*/
SELECT distinct
b_contract_plans.contract_plans_description AS สิทธิ
,count(distinct t_patient.t_patient_id) as คน
,count(distinct t_visit.t_visit_id) as ครั้ง
,sum(t_billing.billing_total) as ค่ารักษา
,sum(t_billing.billing_payer_share) as สิทธิชำระให้
,sum(t_billing.billing_patient_share) as ผู้ป่วยต้องชำระ
,sum(t_billing.billing_paid) as ผู้ป่วยจ่ายแล้วเท่าไร
,sum(t_billing.billing_remain) as ค้างอยู่เท่าไร
 FROM
    t_patient  INNER JOIN t_visit  ON t_patient.t_patient_id = t_visit.t_patient_id
            INNER JOIN t_visit_payment ON (t_visit.t_visit_id = t_visit_payment.t_visit_id AND t_visit_payment.visit_payment_active = '1') 
            INNER JOIN b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
						inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id 
							and t_visit_service.b_service_point_id ='2402024154365'-- 12.แพทย์แผนไทย							
            LEFT JOIN t_billing ON (t_billing.t_visit_id = t_visit.t_visit_id AND t_billing.billing_active = '1')              
WHERE t_visit.f_visit_status_id <> '4'
            AND t_visit_payment.visit_payment_priority = '0'   
          --  AND  b_contract_plans.b_contract_plans_id  not in ('2120000000001') --เบิกได้ผู้ป่วยนอก
            AND t_visit.visit_money_discharge_status = '1'
--  AND substring(t_visit.visit_begin_visit_time,1,10)   between  substring('2557-01-01',1,10) and substring('2557-01-31',1,10)--วันที่รับบริการ 
			AND substring(t_visit.visit_financial_discharge_time,1,10)   between  substring('2560-02-01',1,10) and substring('2560-02-28',1,10)--วันที่รับบริการ 
      --AND substring(t_visit.visit_financial_discharge_time,1,10)   between  substring(?,1,10) and substring(?,1,10)--วันที่รับบริการ 
GROUP BY  สิทธิ
ORDER BY  สิทธิ