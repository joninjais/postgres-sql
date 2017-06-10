SELECT
t_person.person_pid as CID
,r_rp1853_prefix.name as PRENAME
 ,t_person.person_firstname as NAME
 ,t_person.person_lastname as LNAME
            ,case when t_person.f_sex_id='1'
            then 'ชาย'
            else 'หญิง' end as SEX
,t_person.person_birthday AS BIRTH
,b_employee.employee_number as เลขที่ใบประกอบวิชาชีพ
,f_provider_type.description as PROVIDERTYPE
,b_employee.start_date as STARTDATE
,b_employee.provider
FROM b_employee
      INNER JOIN t_person ON b_employee.t_person_id = t_person.t_person_id
        LEFT JOIN f_patient_prefix ON t_person.f_prefix_id = f_patient_prefix.f_patient_prefix_id
        left join b_map_rp1853_prefix on  f_patient_prefix.f_patient_prefix_id = b_map_rp1853_prefix.f_patient_prefix_id
        left join r_rp1853_prefix on b_map_rp1853_prefix.r_rp1853_prefix_id = r_rp1853_prefix.id
        LEFT JOIN f_provider_type ON b_employee.f_provider_type_id = f_provider_type.f_provider_type_id
WHERE employee_active='1'

--and b_employee.b_service_point_id='2404095259815'
and b_employee.f_provider_type_id in ('000002','000006')
--and b_employee.provider='1135400099'
ORDER BY PROVIDERTYPE