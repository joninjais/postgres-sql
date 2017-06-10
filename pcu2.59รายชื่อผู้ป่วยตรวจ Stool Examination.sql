--pcu2.59รายชื่อผู้ป่วยตรวจ Stool Examination ที่มี  Parasite
SELECT  
DISTINCT t_visit.visit_begin_visit_time AS วันรับบริการ
,t_visit.visit_hn AS HN
,t_visit.visit_vn as VN
,f_patient_prefix.patient_prefix_description || '  ' || t_patient.patient_firstname || '   ' ||    t_patient.patient_lastname AS  ชื่อสกุล
    ,date_part('year',age(cast(current_date as date)        
  ,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
 ,t_patient.patient_house as บ้านเลขที่
 ,t_patient.patient_moo as หมู่
 ,f1.address_description as ตำบล
 ,f2.address_description as อำเภอ
 ,f3.address_description as จังหวัด
 ,t_result_lab.result_lab_value as Parasite
 FROM t_visit
inner join t_patient ON t_patient.t_patient_id = t_visit.t_patient_id 
inner join f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
         INNER join f_address as f1 on t_patient.patient_tambon = f1.f_address_id
         INNER join f_address as f2 on t_patient.patient_amphur = f2.f_address_id
         INNER join f_address as f3 on t_patient.patient_changwat = f3.f_address_id
					INNER JOIN t_order on t_order.t_visit_id=t_visit.t_visit_id and t_order.b_item_id='113541023504838'
					INNER JOIN t_result_lab on t_result_lab.t_visit_id=t_visit.t_visit_id
										and t_result_lab.result_lab_value <> 'Not found' 
										and t_result_lab.result_lab_value <> 'not found'
										and t_result_lab.result_lab_value <> ''
                    and t_result_lab.result_lab_active ='1'
										and t_result_lab.result_lab_name ILIKE '%Parasite%'
where 
							 substring(t_visit.visit_begin_visit_time,1,10) between substring('2558-10-01',1,10) AND substring('2559-09-30',1,10)
             --and substring(t_visit.visit_begin_visit_time,1,10) between substring (?,1,10) and substring(?,1 ,10)
--GROUP BY วันรับบริการ , HN , VN , ชื่อสกุล , อายุ , บ้านเลขที่ , หมู่ , ตำบล , อำเภอ , จังหวัด 
ORDER BY วันรับบริการ