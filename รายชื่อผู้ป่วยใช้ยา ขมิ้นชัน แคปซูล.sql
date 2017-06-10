--pharm120รายชื่อผู้ป่วยใช้ยา ขมิ้นชัน แคปซูล
SELECT distinct 
t_visit.visit_begin_visit_time AS วันรับบริการ
,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
,t_visit.visit_hn AS HN
    ,date_part('year',age(cast(current_date as date)        
  ,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
,t_visit.visit_dx as dx
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_main_symptom),' , ') AS อาการสำคัญ
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_current_illness),' , ') AS ประวัติปัจจุบัน
--,t_order.order_common_name as ชื่อยา
--,t_order.order_qty as จำนวนเม็ด
,array_to_string(array_agg(DISTINCT to1.order_qty),' , ') AS จำนวน
--,bidi1.item_drug_instruction_description||' '||tod1.order_drug_dose||' '||bidu1.item_drug_uom_description||' '||bdf1.item_drug_frequency_description as วิธีใช้ยา
,array_to_string(array_agg(DISTINCT 
case when tod1.order_drug_special_prescription='1' 
	then tod1.order_drug_special_prescription_text 
	else bidi1.item_drug_instruction_description||' '||tod1.order_drug_dose||' '||bidu1.item_drug_uom_description||' '||bdf1.item_drug_frequency_description
	end),' , ')
as วิธีใช้ยา
--,case when rl1.result_lab_value <>'' and rl2.result_lab_value <>'' then rl1.result_lab_value||' '||rl1.result_lab_unit else '' end as AST
--,case when rl1.result_lab_value <>'' and rl2.result_lab_value <>'' then rl2.result_lab_value||' '||rl2.result_lab_unit else '' end as ALT
,array_to_string(array_agg(DISTINCT rl1.result_lab_value||' '||rl1.result_lab_unit),' , ') AS AST
,array_to_string(array_agg(DISTINCT rl2.result_lab_value||' '||rl2.result_lab_unit),' , ') AS ALT
,array_to_string(array_agg(DISTINCT rl3.result_lab_value||' '||rl3.result_lab_unit),' , ') AS Total_bilirubin
 FROM t_visit
inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
inner join t_visit_payment ON t_visit_payment.t_visit_id=t_visit.t_visit_id
inner join t_order to1 on to1.t_visit_id=t_visit.t_visit_id
inner join t_order_drug on t_order_drug.t_order_id=to1.t_order_id
inner join b_item on b_item.b_item_id=to1.b_item_id
INNER JOIN t_order_drug tod1 on tod1.t_order_id=to1.t_order_id and tod1.order_drug_active='1' and tod1.order_drug_order_status<>'5'
INNER JOIN b_item_drug_instruction bidi1 on bidi1.b_item_drug_instruction_id=tod1.b_item_drug_instruction_id
INNER JOIN b_item_drug_frequency bdf1 on bdf1.b_item_drug_frequency_id=tod1.b_item_drug_frequency_id
INNER JOIN b_item_drug_uom bidu1 on bidu1.b_item_drug_uom_id=tod1.b_item_drug_uom_id_use
	left join t_result_lab rl1 on rl1.t_visit_id=t_visit.t_visit_id 
		and rl1.result_lab_active='1' and rl1.b_item_lab_result_id ='1772583099494'--AST (SGOT)
	left join t_result_lab rl2 on rl2.t_visit_id=t_visit.t_visit_id 
		and rl2.result_lab_active='1' and rl2.b_item_lab_result_id ='1778246382229'--SGPT (ALT)
	left join t_result_lab rl3 on rl3.t_visit_id=t_visit.t_visit_id 
		and rl3.result_lab_active='1' and rl3.b_item_lab_result_id ='1771761772318'--Total bilirubin
where t_visit.f_visit_status_id <> '4'  
and t_visit_payment.visit_payment_priority = '0'
and b_item.b_item_id='174113545332875388'--ขมิ้นชัน แคปซูล
--and rl1.b_item_lab_result_id in ('1778246382229')--SGPT (ALT)
							and substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-06-31',1,10)
--             and substring(t_visit.visit_begin_visit_time,1,10) between substring (?,1,10) and substring(?,1 ,10)
GROUP BY วันรับบริการ,ชื่อสกุล,HN,อายุ,dx
ORDER BY วันรับบริการ
