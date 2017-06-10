select
*
from
(select
t_health_family.t_health_home_id
,f_patient_family_status.patient_family_status_description
,t_health_home.health_home_house
,t_health_home.health_home_moo
,count(t_health_family_id) as count_HEADID

from
t_health_home inner join t_health_family on t_health_home.t_health_home_id = t_health_family.t_health_home_id
left join f_patient_family_status on t_health_family.f_patient_family_status_id = f_patient_family_status.f_patient_family_status_id

where
t_health_family.health_family_active = '1'
and t_health_home.home_active ='1'
and t_health_family.f_patient_family_status_id ='1' -- 1 = เจ้าบ้าน , 2= ผู้อาศัย
group by
t_health_family.t_health_home_id
,f_patient_family_status.patient_family_status_description
,t_health_home.health_home_house
,t_health_home.health_home_moo
,t_health_family.f_patient_family_status_id

order by
t_health_home.health_home_moo asc
,t_health_home.health_home_house asc
,t_health_family.f_patient_family_status_id asc) as q
where
q.count_HEADID >1