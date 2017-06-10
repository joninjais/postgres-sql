SELECT  distinct
	b_site.b_visit_office_id AS HOSPCODE 				
    ,t_health_family.health_family_hn_hcis as PID 	
    ,t_visit.visit_vn AS SEQ 		
    , case when t_visit.visit_begin_visit_time is not null
                then (to_number(substring(t_visit.visit_begin_visit_time,1,5),'9999')-543)
                        || substring(t_visit.visit_begin_visit_time,6,2)
                        || substring(t_visit.visit_begin_visit_time,9,2)
              when  t_health_anc.health_anc_survey is not null and trim(t_health_anc.health_anc_survey) <> ''
                then (to_number(substring(t_health_anc.health_anc_survey,1,5),'9999')-543)
                        || substring(t_health_anc.health_anc_survey,6,2)
                        || substring(t_health_anc.health_anc_survey,9,2)
               else (to_number(substring(t_health_anc.modify_date_time,1,5),'9999')-543)
                        || substring(t_health_anc.modify_date_time,6,2)
                        || substring(t_health_anc.modify_date_time,9,2)
     end AS DATE_SERV 
    , t_health_pregnancy.health_pregnancy_gravida_number AS GRAVIDA
    , t_health_anc.f_health_anc_section AS ANCNO
    , t_health_anc.health_anc_gravida_week AS  GA
    , case when t_health_anc.health_anc_exam ='1'
		then '1'
		when t_health_anc.health_anc_exam ='2'
		then '2'
		else '9' end AS ANCRESULT
    , t_health_pregnancy.b_visit_office_id AS ANCPLACE
    ,b_employee.provider as PROVIDER
    ,(case  when length(t_visit.visit_staff_doctor_discharge_date_time) >= 10
                then case when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_visit.visit_staff_doctor_discharge_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_visit.visit_staff_doctor_discharge_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else '' end
  when length(t_health_anc.modify_date_time) >= 10
                then case when length(cast(substring(t_health_anc.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_anc.modify_date_time,5),'-',''),',',''),':','')) = 14
                                  then (cast(substring(t_health_anc.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_anc.modify_date_time,5),'-',''),',',''),':',''))
                                  when length(cast(substring(t_health_anc.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_anc.modify_date_time,5),'-',''),',',''),':','')) =12
                                  then (cast(substring(t_health_anc.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_anc.modify_date_time,5),'-',''),',',''),':','')) || '00'
                                  when length(cast(substring(t_health_anc.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_anc.modify_date_time,5),'-',''),',',''),':','')) =10
                                  then (cast(substring(t_health_anc.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_anc.modify_date_time,5),'-',''),',',''),':','')) || '0000'
                                  when length(cast(substring(t_health_anc.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_anc.modify_date_time,5),'-',''),',',''),':','')) = 8
                                  then (cast(substring(t_health_anc.modify_date_time,1,4) as numeric) - 543
                                                || replace(replace(replace(substring(t_health_anc.modify_date_time,5),'-',''),',',''),':','')) || '000000'
                                  else ''
                           end            
                else ''
       end)  as D_UPDATE 



FROM t_health_anc 			
	INNER JOIN t_health_family ON t_health_anc.t_health_family_id = t_health_family.t_health_family_id      			
	INNER JOIN t_visit ON t_health_anc.t_visit_id = t_visit.t_visit_id 		
        INNER JOIN t_health_pregnancy ON t_health_anc.t_health_pregnancy_id = t_health_pregnancy.t_health_pregnancy_id and t_health_pregnancy.health_pregnancy_active='1'
        LEFT JOIN b_employee ON t_health_anc.health_anc_staff_record = b_employee.b_employee_id 

        left join t_death on t_health_family.t_health_family_id = t_death.t_health_family_id
                                    and t_death.death_active = '1'

	,b_site
WHERE  
        t_health_anc.health_anc_active = '1'         
        AND t_health_family.health_family_active = '1' 
        AND t_visit.f_visit_type_id <> 'S' 
        AND t_visit.f_visit_status_id ='3'
        AND t_visit.visit_money_discharge_status='1'
        AND t_visit.visit_doctor_discharge_status='1'

--ก่อน 12 สัปดาห์

--and   t_visit.visit_hn = '530030863' --ภัทราวดี
--and   t_visit.visit_hn = '550047375' --พัชรี



 
-- 5 ครั้ง คุณภาพ	
and   t_visit.visit_hn = '000015244' --กาญจนา
--and   t_visit.visit_hn = '570066789' --กาญจนา
--and   t_visit.visit_hn = '530032549' --อรุณรัตน์
--and   t_visit.visit_hn = '520002468' --ปรียา

			
        AND substr( t_visit.visit_staff_doctor_discharge_date_time,1,10) between '2559-01-01' and '2559-12-31'                        

        and (case when t_death.t_death_id is not null 
                    then true 
               when t_death.t_death_id is null and t_health_family.f_patient_discharge_status_id <> '1'
                    then true 
                    else false end)

ORDER BY GRAVIDA