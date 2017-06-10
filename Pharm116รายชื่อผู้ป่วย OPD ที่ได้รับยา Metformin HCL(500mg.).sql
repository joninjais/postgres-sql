--Pharm116รายชื่อผู้ป่วยที่ได้รับยา Metformin HCL(500mg.)
SELECT  
t_visit.visit_begin_visit_time AS วันรับบริการ
,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
,t_visit.visit_hn AS HN
,t_visit.visit_vn as VN
    ,date_part('year',age(cast(current_date as date)        
  ,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
      , t_patient.patient_house || '  ม.' ||t_patient.patient_moo || ' ต.' ||f1.address_description || '  อ.' ||
         f2.address_description || ' จ.' ||f3.address_description as ที่อยู่
, t_patient.patient_phone_number ||','||t_patient.patient_contact_phone_number as "เบอร์โทร"
,array_to_string(array_agg(DISTINCT t_visit_vital_sign.visit_vital_sign_blood_presure),' , ') AS BP
,array_to_string(array_agg(DISTINCT t_visit_vital_sign.visit_vital_sign_heart_rate),' , ') AS PR
,array_to_string(array_agg(DISTINCT t_visit_vital_sign.visit_vital_sign_weight),' , ') AS น้ำหนัก
,array_to_string(array_agg(DISTINCT t_visit_vital_sign.visit_vital_sign_height),' , ') AS ส่วนสูง

,t_visit.visit_dx as dx
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_main_symptom),' , ') AS อาการสำคัญ
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_current_illness),' , ') AS ประวัติปัจจุบัน
--,t_order.order_common_name as ชื่อยา
--,t_order.order_qty as จำนวนเม็ด
,b_employee.employee_firstname AS ผู้ยืนยัน
,array_to_string(array_agg(DISTINCT to1.order_qty),' , ') AS จำนวนจ่าย

--,to1.order_qty as จำนวนจ่าย
--,bidi1.item_drug_instruction_description||' '||tod1.order_drug_dose||' '||bidu1.item_drug_uom_description||' '||bdf1.item_drug_frequency_description as วิธีใช้ยา
,substring(to1.order_date_time,1,10) AS วันทีสั่ง
,array_to_string(array_agg(DISTINCT 
case when tod1.order_drug_special_prescription='1' 
	then tod1.order_drug_special_prescription_text 
	else bidi1.item_drug_instruction_description||' '||tod1.order_drug_dose||' '||bidu1.item_drug_uom_description||' '||bdf1.item_drug_frequency_description
	end),' , ')
as วิธีใช้ยา
--,case when rl1.result_lab_value <>'' and rl2.result_lab_value <>'' then rl1.result_lab_value||' '||rl1.result_lab_unit else '' end as AST
--,case when rl1.result_lab_value <>'' and rl2.result_lab_value <>'' then rl2.result_lab_value||' '||rl2.result_lab_unit else '' end as ALT

 FROM t_visit
inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
inner join t_visit_payment ON t_visit_payment.t_visit_id=t_visit.t_visit_id
inner join t_order to1 on to1.t_visit_id=t_visit.t_visit_id and to1.f_order_status_id<>'3'
inner join t_order_drug on t_order_drug.t_order_id=to1.t_order_id
inner join b_item on b_item.b_item_id=to1.b_item_id
INNER JOIN t_order_drug tod1 on tod1.t_order_id=to1.t_order_id and tod1.order_drug_active='1' and tod1.order_drug_order_status<>'5'
INNER JOIN b_item_drug_instruction bidi1 on bidi1.b_item_drug_instruction_id=tod1.b_item_drug_instruction_id
INNER JOIN b_item_drug_frequency bdf1 on bdf1.b_item_drug_frequency_id=tod1.b_item_drug_frequency_id
INNER JOIN b_item_drug_uom bidu1 on bidu1.b_item_drug_uom_id=tod1.b_item_drug_uom_id_use
left join t_visit_vital_sign on t_visit_vital_sign.t_visit_id = t_visit.t_visit_id 
        LEFT JOIN f_address as f1 ON t_patient.patient_tambon = f1.f_address_id
        LEFT JOIN f_address as f2 ON t_patient.patient_amphur =f2.f_address_id
        LEFT JOIN f_address as f3 ON t_patient.patient_changwat= f3.f_address_id 
				LEFT JOIN b_employee  ON to1.order_staff_verify = b_employee.b_employee_id
where t_visit.f_visit_status_id <> '4'  
and t_visit_payment.visit_payment_priority = '0'
and t_visit.f_visit_type_id='0' --ผู้ป่วยนอก 
--and b_item.b_item_id='1740000000184'--Metformin  HCL .-tab (500mg.)
and b_item.b_item_id='1740000000184'--Metformin  HCL .-tab (500mg.)
--and rl1.b_item_lab_result_id in ('1778246382229')--SGPT (ALT)

							and substring(t_visit.visit_begin_visit_time,1,10) between substring('2559-09-01',1,10) AND substring('2559-09-10',1,10)
--             and substring(t_visit.visit_begin_visit_time,1,10) between substring (?,1,10) and substring(?,1 ,10)
GROUP BY วันรับบริการ,ชื่อสกุล,HN,อายุ,dx,vn,เบอร์โทร,ที่อยู่ ,วันทีสั่ง , ผู้ยืนยัน
ORDER BY วันรับบริการ
