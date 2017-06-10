--pharm121รายชื่อผู้ป่วยใช้ยาDigoxin.-inj 0.5mg 2ml
SELECT distinct 
t_visit.visit_begin_visit_time AS วันรับบริการ
,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
,t_visit.visit_hn AS HN

    ,date_part('year',age(cast(current_date as date)        
  ,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
--,vs1.visit_vital_sign_weight as น้ำหนัก
,array_to_string(array_agg(DISTINCT vs1.visit_vital_sign_weight),' , ') AS น้ำหนัก
--,t_visit.t_visit_id
--,t_visit.visit_vn as vn
   -- ,t_visit.visit_hn AS HN
,t_visit.visit_dx as dx
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_main_symptom),' , ') AS อาการสำคัญ
,array_to_string(array_agg(DISTINCT t_visit_primary_symptom.visit_primary_symptom_current_illness),' , ') AS ประวัติปัจจุบัน
,array_to_string(array_agg(DISTINCT vs1.visit_vital_sign_heart_rate),' , ') AS ชีพจร
,array_to_string(array_agg(DISTINCT vs1.visit_vital_sign_blood_presure),' , ') AS ความดัน
,array_to_string(array_agg(DISTINCT to1.order_qty),' , ') AS จำนวน
--,bdi1.item_drug_instruction_description as วิธีใช้ยา
,array_to_string(array_agg(DISTINCT 
case when tod1.order_drug_special_prescription='1' 
	then tod1.order_drug_special_prescription_text 
	else bidi1.item_drug_instruction_description||' '||tod1.order_drug_dose||' '||bidu1.item_drug_uom_description||' '||bdf1.item_drug_frequency_description
	end),' , ')
as วิธีใช้ยา
--,array_to_string(array_agg(DISTINCT rl1.result_lab_value),' , ') AS eGFR
--,array_to_string(array_agg(DISTINCT rl2.result_lab_value),' , ') AS Creatinine
,case when qr1.egfr[1]<>'' then qr1.egfr[1] else '' end as "eGFR ครั้งที่1"
,case when qr1.egfr[2]<>'' then qr1.egfr[2] else '' end as "eGFR ครั้งที่2"
,case when qr1.egfr[3]<>'' then qr1.egfr[3] else '' end as "eGFR ครั้งที่3"
,case when qr2.Creatinine[1]<>'' then qr2.Creatinine[1] else '' end as "Creatinine ครั้งที่1"
,case when qr2.Creatinine[2]<>'' then qr2.Creatinine[2] else '' end as "Creatinine ครั้งที่2"
,case when qr2.Creatinine[3]<>'' then qr2.Creatinine[3] else '' end as "Creatinine ครั้งที่3"
FROM t_visit
inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
--inner join t_visit_payment ON t_visit_payment.t_visit_id=t_visit.t_visit_id
inner join t_visit_vital_sign vs1 ON vs1.t_visit_id=t_visit.t_visit_id
inner join t_order to1 on to1.t_visit_id=t_visit.t_visit_id and f_order_status_id <> '3'
inner join b_item on b_item.b_item_id=to1.b_item_id
INNER JOIN t_order_drug tod1 on tod1.t_order_id=to1.t_order_id and tod1.order_drug_active='1' and tod1.order_drug_order_status<>'5'
INNER JOIN b_item_drug_instruction bidi1 on bidi1.b_item_drug_instruction_id=tod1.b_item_drug_instruction_id
INNER JOIN b_item_drug_frequency bdf1 on bdf1.b_item_drug_frequency_id=tod1.b_item_drug_frequency_id
INNER JOIN b_item_drug_uom bidu1 on bidu1.b_item_drug_uom_id=tod1.b_item_drug_uom_id_use
					--left join t_result_lab rl1 on rl1.t_visit_id=t_visit.t_visit_id 
							--and rl1.result_lab_active='1' and rl1.b_item_lab_result_id in ('177113547963448107')--eGFR-ckd
					LEFT JOIN (
											select 
                t_visit.t_visit_id
                ,t_visit.visit_hn
                --,t_visit.visit_vn
                ,array_agg(case when trim(t_result_lab.result_lab_name) ilike '%eGFR%'  
                    then result_lab_value else '' end) as egfr

            from t_order
                left join t_visit on t_visit.t_visit_id = t_order.t_visit_id
                left join t_result_lab ON (t_order.t_order_id = t_result_lab.t_order_id 
                    and t_result_lab.result_lab_value <> '' 
                    and t_result_lab.result_lab_active ='1'
                    and (trim(t_result_lab.result_lab_name) ilike '%eGFR%')) 

            where t_result_lab.result_lab_name ilike '%eGFR%'
                and f_order_status_id <> '3'
                and  substr(t_visit.visit_begin_visit_time,1,10) between '2558-10-01' and '2559-06-31'
                --and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
                --and t_visit.visit_hn='520000133'
            group by t_visit.t_visit_id
                ,t_visit.visit_hn
										)as qr1 on qr1.t_visit_id=t_visit.t_visit_id
					LEFT JOIN (
											select 
                t_visit.t_visit_id
                ,t_visit.visit_hn
                --,t_visit.visit_vn
                ,array_agg(case when trim(t_result_lab.result_lab_name) ilike '%Creatinine%'  
                    then result_lab_value else '' end) as Creatinine

            from t_order
                left join t_visit on t_visit.t_visit_id = t_order.t_visit_id
                left join t_result_lab ON (t_order.t_order_id = t_result_lab.t_order_id 
                    and t_result_lab.result_lab_value <> '' 
                    and t_result_lab.result_lab_active ='1'
                    and (trim(t_result_lab.result_lab_name) ilike '%Creatinine%')) 

            where t_result_lab.result_lab_name ilike '%Creatinine%'
                and f_order_status_id <> '3'
                and  substr(t_visit.visit_begin_visit_time,1,10) between '2558-10-01' and '2559-06-31'
                --and substring(t_visit.visit_begin_visit_time,1,10) between substring(?,1,10) and substring(?,1,10)
                --and t_visit.visit_hn='520000133'
            group by t_visit.t_visit_id
                ,t_visit.visit_hn
										)as qr2 on qr2.t_visit_id=t_visit.t_visit_id
					--left join t_result_lab rl2 on rl2.t_visit_id=t_visit.t_visit_id 
					--		and rl2.result_lab_active='1' and rl2.b_item_lab_result_id in ('1778697729294')--Creatinine
--t_visit_service.b_service_point_id ='2409144269314' --ห้องฉุกเฉิน
where t_visit.f_visit_status_id <> '4'  
--and b_contract_plans.contract_plans_active = '1'
--and vs1.visit_vital_sign_heart_rate < '60'

and b_item.b_item_id='1740000000093'--**Digoxin.-inj  (0.5mg /2ml)**
							and substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-06-31',1,10)
--             and substring(t_visit.visit_begin_visit_time,1,10) between substring (?,1,10) and substring(?,1 ,10)
GROUP BY วันรับบริการ,ชื่อสกุล,HN,อายุ,dx,"eGFR ครั้งที่1","eGFR ครั้งที่2","eGFR ครั้งที่3","Creatinine ครั้งที่1","Creatinine ครั้งที่2","Creatinine ครั้งที่3"
ORDER BY วันรับบริการ
