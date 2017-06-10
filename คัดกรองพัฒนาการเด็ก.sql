--คัดกรองพัฒนาการเด็ก
select distinct(t_visit.visit_Hn) AS Hn
,f_patient_prefix.patient_prefix_description || '' || t_patient.patient_firstname || '   ' || t_patient.patient_lastname AS "ชื่อ-สกุล"
,t_patient.patient_pid as รหัสบัตรประชาชน
,t_patient.patient_moo as หมู่
--,SUBSTRING(t_patient.patient_birthday,1,10) as วันเกิด

,substring(t_patient.patient_birthday,6,2)||'-'||substring(t_patient.patient_birthday,6,2)||'-'||(substring(t_patient.patient_birthday,1,4)) as birthday
 ,date_part('year',age(cast(current_date as date)
       ,cast((cast(substring(t_health_family.patient_birthday,1,4) as numeric) - 543 
        || substring(t_health_family.patient_birthday,5))   as date)))  ||' ปี '||  

        date_part('mon',age(cast(current_date as date)
        ,cast((cast(substring(t_health_family.patient_birthday,1,4) as numeric) - 543 
        || substring(t_health_family.patient_birthday,5))  as date)))   ||' เดือน ' as  อายุ

        , date_part('day',age(cast(current_date as date)
        ,cast((cast(substring(t_health_family.patient_birthday,1,4) as numeric) - 543 
        || substring(t_health_family.patient_birthday,5)) as date))) ||' วัน'   as อายุ_วัน

--, visit_patient_age as อายุ

from t_visit
inner join t_patient
    on t_visit.t_patient_id = t_patient.t_patient_id
inner join f_patient_prefix
 on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id 
inner join f_address 
 on f_address.f_address_id = t_patient.patient_tambon

inner join t_health_family 
    on t_patient.t_health_family_id = t_health_family.t_health_family_id
  
where t_patient.patient_moo in('1','01','2','02','4','04','6','06','9','09','10','12','13')
and f_address.address_description like'ท้ายเหมือง'
and  t_patient.f_patient_nation_id = '99'  --คนไทย
--and SUBSTRING(t_patient.patient_birthday,1,10)  between '2558-09-05' and '2558-10-08' --9  เดือน
--and SUBSTRING(t_patient.patient_birthday,1,10)  between '2557-12-05' and '2558-01-08' --18 เดือน
--and SUBSTRING(t_patient.patient_birthday,1,10)  between '2556-12-05' and '2557-01-08' --30 เดือน
and SUBSTRING(t_patient.patient_birthday,1,10)  between '2555-12-05' and '2556-01-08' --42 เดือน
--substring(?,1,10) and substring(?,1,10)