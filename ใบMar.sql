SELECT q.continue,q.common_name,q.hn ,q.vn ,q.pid,xn ,q.patient_type,
q.dispense_unit,q.uom ,q.long_dose,q.dose_special
,q.plan,name,q.datevisit,q.time,q.print_date,q.print_time,q.dx,q.age,q.qty , q.subhospital
	,q.mainhospital
	, q.dx_note
	,q.execute
	, q.verifyname
, q.hospital
,q.admit
,q.admit_time
--,array_to_string(array_agg(q.drug_allergy),' , ') as drug_allergy
 from ( select distinct
t_order.order_continue as continue
	,t_order.order_common_name       AS common_name
	,t_visit.visit_hn    AS hn
	,t_visit.visit_vn       AS vn
	,t_patient.patient_pid      AS pid
	,t_patient.patient_xn			   AS xn
	,f_visit_type.visit_type_description                       AS patient_type
	,b_item_drug_uom.item_drug_uom_description                 AS dispense_unit
,case when uom_purch.item_drug_uom_description is null then 'ชิ้น,อัน' else uom_purch.item_drug_uom_description end as uom
,b_item_drug_instruction.item_drug_instruction_description || ' ' || t_order_drug.order_drug_dose|| ' ' || b_item_drug_uom.item_drug_uom_description ||'  '|| b_item_drug_frequency.item_drug_frequency_description  AS long_dose
,case when t_order_drug.order_drug_special_prescription_text is null then '' else t_order_drug.order_drug_special_prescription_text end as dose_special
   	,b_contract_plans.contract_plans_description               AS plan
	,f_patient_prefix.patient_prefix_description||' '||t_patient.patient_firstname ||'  '|| t_patient.patient_lastname       AS name
    	,cast(cast(substring(t_visit.visit_begin_visit_time,1,4) as numeric) -543
		|| substring(t_visit.visit_begin_visit_time,5,6) as DATE)   as datevisit
	,substring(t_visit.visit_begin_visit_time,12,5)      AS time
	,CURRENT_DATE  AS print_date
	,CURRENT_TIME AS print_time
    	,t_visit.visit_dx                                          AS dx
	,t_visit.visit_patient_age                                 AS age

	,t_order.order_qty                                         AS qty

    	,b_visit_office_1.visit_office_name                        AS subhospital
	,b_visit_office.visit_office_name                          AS mainhospital
	,t_visit.visit_diagnosis_notice 			       AS dx_note
	,b_employee.employee_firstname                             AS execute
	,b_employee_1.employee_firstname                           AS verifyname
    	,b_site.site_name   				       AS hospital
,cast(cast(substr(t_visit.visit_begin_visit_time,1,4) as numeric) - 543|| (substr(t_visit.visit_begin_visit_time,5,6))as date ) as admit
,substring(t_visit.visit_begin_admit_date_time,12,5) as admit_time
--,array_to_string(array_agg(b_item_drug_standard.item_drug_standard_description),' , ') as drug_allergy
--,b_item_drug_standard.item_drug_standard_description   as drug_allergy
FROM
 t_order
	INNER JOIN t_visit ON t_visit.t_visit_id = t_order.t_visit_id
	INNER JOIN public.b_employee b_employee ON t_order.order_staff_verify = b_employee.b_employee_id
	LEFT JOIN public.b_employee b_employee_1 ON t_order.order_staff_execute = b_employee_1.b_employee_id
	left join t_order_drug ON (t_order.t_order_id = t_order_drug.t_order_id)
	LEFT JOIN public.b_item_drug_instruction b_item_drug_instruction ON t_order_drug.b_item_drug_instruction_id = b_item_drug_instruction.b_item_drug_instruction_id
	LEFT JOIN public.b_item_drug_frequency b_item_drug_frequency ON t_order_drug.b_item_drug_frequency_id = b_item_drug_frequency.b_item_drug_frequency_id
	LEFT JOIN public.b_item_drug_uom b_item_drug_uom ON t_order_drug.b_item_drug_uom_id_use = b_item_drug_uom.b_item_drug_uom_id
	INNER JOIN public.f_visit_type f_visit_type ON t_visit.f_visit_type_id = f_visit_type.f_visit_type_id
--	LEFT JOIN public.t_diag_icd10 t_diag_icd10 ON (t_diag_icd10.diag_icd10_vn = t_visit.t_visit_id  and t_diag_icd10.f_diag_icd10_type_id ='1')
	--LEFT JOIN public.b_icd10 b_icd10 ON t_diag_icd10.diag_icd10_number = b_icd10.icd10_number
	left JOIN public.t_visit_payment t_visit_payment ON t_visit_payment.t_visit_id = t_visit.t_visit_id and t_visit_payment.visit_payment_priority = '0' and visit_payment_active = '1'
	LEFT JOIN public.b_visit_office b_visit_office ON b_visit_office.b_visit_office_id = t_visit_payment.visit_payment_main_hospital
	INNER JOIN public.b_contract_plans b_contract_plans ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
	LEFT JOIN public.b_visit_office b_visit_office_1 ON b_visit_office_1.b_visit_office_id = t_visit_payment.visit_payment_sub_hospital
	INNER JOIN public.t_patient t_patient ON t_patient.t_patient_id = t_visit.t_patient_id
	LEFT JOIN  public.f_patient_prefix f_patient_prefix ON f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id
left join b_item_drug_uom as uom_use on t_order_drug.b_item_drug_uom_id_use = uom_use.b_item_drug_uom_id
left join b_item_drug_uom as uom_purch on t_order_drug.b_item_drug_uom_id_purch = uom_purch.b_item_drug_uom_id
 left join t_patient_drug_allergy on t_patient.t_patient_id = t_patient_drug_allergy.t_patient_id
            left join b_item_drug_standard on t_patient_drug_allergy.b_item_drug_standard_id = b_item_drug_standard.b_item_drug_standard_id
	CROSS JOIN public.b_site b_site
where t_order.f_item_group_id = '1' and t_order.order_home <> '1' and t_order.f_order_status_id  <> '3'
--and t_order.t_visit_id = '255113543989633455'
and t_order.t_visit_id = '255113543998160452'--$P{visit_id}
and t_order.print_mar_type = '1' -- 1=ยาเม็ด  ,  2 = 'สารน้ำ'
 --and substr(t_visit.visit_begin_admit_date_time,1,10) = substr(t_order.order_verify_date_time,1,10)
)q
group by
q.continue,q.common_name,q.hn ,vn ,q.pid,xn ,q.patient_type,
q.dispense_unit,q.uom ,q.long_dose,q.dose_special
,q.plan,name,q.datevisit,q.time,q.print_date,q.print_time,q.dx,q.age,q.qty , q.subhospital
	,q.mainhospital
	, q.dx_note
	,q.execute
	, q.verifyname
, q.hospital
,q.admit
,q.admit_time
--,q.drug_allergy
order by continue;