---pharm043รายชื่อผู้ป่วยแพ้ยา
--ผู้ป่วยแพ้ยา   
select distinct substr(t_patient_drug_allergy.record_date_time,1,10) as วันเวลาที่บันทึก
,t_patient.patient_hn as HN
,t_visit.visit_vn
,f_patient_prefix.patient_prefix_description  || '' ||t_patient.patient_firstname||'   '||t_patient.patient_lastname as ชื่อผู้ป่วย
,(to_number(substring(' ' || age(to_date(SUBSTRING(t_patient_drug_allergy.drug_allergy_symtom_date,1,10),'YYYY-MM-DD'), to_date(t_patient.patient_birthday,'YYYY-MM-DD')) from '(...)year'),'999') ) as อายุ
,f_address.address_description as ตำบล
,f_address1.address_description as อำเภอ
,b_item_drug_standard.item_drug_standard_description as ชื่อสามัญทางยา
,f_allergy_type.allergy_type_description as ประเภทอาการที่แพ้
,t_patient_drug_allergy.drug_allergy_symtom as ADRอาการ
,f_naranjo_interpretation.naranjo_interpretation_detail as ผลการประเมิน
,t_naranjo.naranjo_total as คะแนนรวม_naranjo
,t_patient_drug_allergy.drug_allergy_symtom_date    as วันที่มีอาการ
,t_patient_drug_allergy.drug_allergy_report_date     as วันที่รายงาน
,f_allergy_warning_type.warning_type_description as การเตือน
,f_allergy_informant.allergy_informant_description as ผู้ให้ประวัติการแพ้ยา
,t_patient_drug_allergy.drug_allergy_note      as หมายเหตุ
--,t_patient_drug_allergy.drug_allergy_note as ผู้ให้ประวัติการแพ้ยา
	/*,t_patient.patient_house as บ้านเลขที่
	,t_patient.patient_road as ถนน
	,t_patient.patient_moo as หมู่*/
	/*,f_address1.address_description as อำเภอ
	,f_address2.address_description as จังหวัด*/
,a2.employee_firstname||' '||a2.employee_lastname as แพทย์ผู้วินิจฉัย
,a1.employee_firstname||' '||a1.employee_lastname as เภสัชผู้ประเมิน
from t_visit
inner join t_patient on t_visit.visit_hn = t_patient.patient_hn
inner join t_patient_drug_allergy on t_patient.t_patient_id = t_patient_drug_allergy.t_patient_id
inner join b_item_drug_standard on b_item_drug_standard.b_item_drug_standard_id = t_patient_drug_allergy.b_item_drug_standard_id
inner join b_employee  as a1 on a1.b_employee_id = t_patient_drug_allergy.user_record
left join b_employee  as a2 on a2.b_employee_id = t_patient_drug_allergy.doctor_diag_id
left join f_naranjo_interpretation on f_naranjo_interpretation.f_naranjo_interpretation_id = t_patient_drug_allergy.f_naranjo_interpretation_id
inner join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
left join t_naranjo on t_naranjo.t_patient_drug_allergy_id = t_patient_drug_allergy.t_patient_drug_allergy_id
INNER JOIN f_address  on f_address.f_address_id = t_patient.patient_tambon
INNER JOIN f_address as f_address1 on f_address1.f_address_id = t_patient.patient_amphur
INNER JOIN f_address as f_address2 on f_address2.f_address_id = t_patient.patient_changwat
INNER JOIN f_allergy_warning_type on f_allergy_warning_type.f_allergy_warning_type_id = t_patient_drug_allergy.f_allergy_warning_type_id
INNER JOIN f_allergy_type on f_allergy_type.f_allergy_type_id = t_patient_drug_allergy.f_allergy_type_id
INNER JOIN f_allergy_informant on f_allergy_informant.f_allergy_informant_id = t_patient_drug_allergy.f_allergy_informant_id
where
--  substring(t_patient_drug_allergy.record_date_time,1,10)   between substr(?,1,10) and substr(?,1,10)
  substring(t_patient_drug_allergy.record_date_time,1,10)   between substr('2560-01-01',1,10) and substr('2560-02-06',1,10)
--and substr(t_patient_drug_allergy.record_date_time,1,10)between substring('2557-01-01',1,10) AND substring('2557-01-10',1,10)
--substring(t_patient_drug_allergy.drug_allergy_report_date ,1,10)   between substr('2557-01-01',1,10) and substr('2557-01-10',1,10)

and t_visit.f_visit_type_id='1'

