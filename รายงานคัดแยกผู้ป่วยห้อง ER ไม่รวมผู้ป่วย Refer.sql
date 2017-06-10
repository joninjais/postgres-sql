--er032 รายชื่อผู้ป่วย ER แยกตามประเภทความรุนแรง
SELECT  t_visit.visit_hn AS HN
,t_visit.visit_vn as vn
    ,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
   -- ,t_visit.visit_hn AS HN
    ,date_part('year',age(cast(current_date as date)        
  ,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
  ,t_visit.visit_begin_visit_time AS วันรับบริการ
  ,f_trama_status.description AS ประเภทการมา_รพ
  ,f_emergency_status.emergency_status_description AS ระดับความรุนแรง
	,case when t_visit.f_emergency_status_id in ('3','4') then 'ระดับ 1+2'
				when t_visit.f_emergency_status_id = '2' then 'ระดับ 3'
				when t_visit.f_emergency_status_id = '5' then 'ระดับ 4'
				when t_visit.f_emergency_status_id = '1' then 'ระดับ 5'
				when t_visit.f_emergency_status_id = '0' then 'ผู้มารับบริการที่อื่น'
	else '' end as ptype
,t_visit.visit_have_refer as refer
 FROM t_visit
inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join f_trama_status on t_visit.f_trama_status_id=f_trama_status.f_trama_status_id
inner join f_emergency_status on t_visit.f_emergency_status_id=f_emergency_status.f_emergency_status_id
inner join t_visit_primary_symptom on t_visit_primary_symptom.t_visit_id = t_visit.t_visit_id
inner join t_visit_payment ON t_visit_payment.t_visit_id=t_visit.t_visit_id
inner join b_contract_plans ON b_contract_plans.b_contract_plans_id = t_visit_payment.b_contract_plans_id
inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2409144269314'
--t_visit_service.b_service_point_id ='2409144269314' --ห้องฉุกเฉิน
where t_visit.f_visit_status_id <> '4'  
and b_contract_plans.contract_plans_active = '1'   
and t_visit_payment.visit_payment_priority = '0'
and t_visit.visit_have_refer='0'
	and substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) AND substring('2558-10-31',1,10)
            -- and substring(t_visit.visit_begin_visit_time,1,10) between substring (?,1,10) and substring(?,1 ,10)
 GROUP BY
   HN
	,vn
   ,ชื่อสกุล
   ,อายุ
   ,วันรับบริการ
   ,ประเภทการมา_รพ
   ,ระดับความรุนแรง
		,ptype
		,refer