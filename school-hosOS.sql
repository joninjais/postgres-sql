select b_site.b_visit_office_id as hospcode 
        ,t_health_village.village_number||t_health_school.school_number as schoolcode
        ,t_health_school.school_name as schoolname 
        ,lpad(t_health_school.school_number,2,'0') as depend 
        ,max(b_school_class.school_class_number) as maxclass 
        ,(case when length(t_health_school.school_modify_date_time) >= 10 
                then case when length(cast(substring(t_health_school.school_modify_date_time,1,4) as numeric) - 543 
                                                || replace(substring(t_health_school.school_modify_date_time,5),',',' ')) = 19 
                                  then (cast(substring(t_health_school.school_modify_date_time,1,4) as numeric) - 543 
                                                || replace(substring(t_health_school.school_modify_date_time,5),',',' ')) 
                                  else '' end 
                 else '' end) as dateupdate  
from t_health_school 
left join t_health_visit_school on t_health_school.t_health_school_id = t_health_visit_school.t_health_school_id 
left join b_school_class on t_health_visit_school.b_school_class_id = b_school_class.b_school_class_id 
left  JOIN t_health_village on t_health_school.t_health_village_id = t_health_village.t_health_village_id
cross join b_site 
where school_active = '1'
group by b_site.b_visit_office_id 
        ,t_health_school.school_name 
        ,lpad(t_health_school.school_number,2,'0') 
        ,dateupdate
        ,schoolcode