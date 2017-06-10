--OPD073-รายชื่อผู้ป่วย DM ทั้งหมด
SELECT 
t.patient_hn AS HN
,f_patient_prefix.patient_prefix_description|| ' ' || t.patient_firstname || ' ' || t.patient_lastname as  "ชื่อ-สกุล"
,   date_part('year',age(cast(current_date as date)
        ,cast((cast(substring(t.patient_birthday,1,4) as numeric) - 543 
        || substring(t.patient_birthday,5))   as date)))   as "อายุ(ปี)"
 ,t.patient_pid AS เลขบัตรประชาชน
 ,t.patient_house as บ้านเลขที่
 , t.patient_moo as หมู่
 , f1.address_description as ตำบล
 , f2.address_description as อำเภอ
 ,f3.address_description as จังหวัด
--,bng.ncd_group_description as description 
FROM t_patient t
INNER JOIN t_patient_ncd tpn on tpn.t_patient_id=t.t_patient_id
INNER JOIN b_ncd_group bng on bng.b_ncd_group_id=tpn.b_ncd_group_id
inner join f_patient_prefix ON t.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
 LEFT JOIN f_address as f1 ON t.patient_tambon = f1.f_address_id
 LEFT JOIN f_address as f2 ON t.patient_amphur =f2.f_address_id
 LEFT JOIN f_address as f3 ON t.patient_changwat= f3.f_address_id
WHERE bng.b_ncd_group_id='2897389127774'--DM
and t.patient_active='1'

--LIMIT 10