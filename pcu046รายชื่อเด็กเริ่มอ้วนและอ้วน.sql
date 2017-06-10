--pcu046รายชื่อเด็กเริ่มอ้วนและอ้วน
SELECT DISTINCT
t_patient.patient_hn as hn
,f_patient_prefix.patient_prefix_description || '' || t_patient.patient_firstname || '   ' || t_patient.patient_lastname AS "ชื่อ-สกุล"
,t_patient.patient_pid as รหัสบัตรประชาชน 
,t_patient.patient_birthday as birthday
    ,date_part('year',age(cast(current_date as date)        
  ,cast((cast(substring(t_patient.patient_birthday,1,4) as numeric) - 543 
       || substring(t_patient.patient_birthday,5))   as date))) AS อายุ
 ,t_patient.patient_house as บ้านเลขที่
 ,t_patient.patient_moo as หมู่
 ,f1.address_description as ตำบล
 ,f2.address_description as อำเภอ
 ,f3.address_description as จังหวัด
 --,f1.f_address_id
--,f_hw_level.hw_level_description as ประเภท
FROM t_health_nutrition 
INNER JOIN t_patient  on t_patient.patient_hn=t_health_nutrition.health_nutrition_hn
inner join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
         INNER join f_address as f1 on t_patient.patient_tambon = f1.f_address_id
         INNER join f_address as f2 on t_patient.patient_amphur = f2.f_address_id
         INNER join f_address as f3 on t_patient.patient_changwat = f3.f_address_id
LEFT JOIN f_hw_level on f_hw_level.f_hw_level_id=t_health_nutrition.f_hw_level_id 
WHERE t_health_nutrition.f_hw_level_id in ('5','6')
and t_health_nutrition.health_nutrition_active='1'
and f1.f_address_id='820801'
and SUBSTRING(t_health_nutrition.record_date_time,1,10)  between '2558-10-01' and '2559-09-30' 
--and SUBSTRING(t_health_nutrition.record_date_time,1,10)  between ? and ? 
-- thn.health_nutrition_hn='000056021'

