select
 count (DISTINCT t_visit.visit_hn) as จำนวนคน
,count (DISTINCT t_visit.visit_vn) as จำนวนครั้ง
--,sum(to_date(visit_staff_doctor_discharge_date_time,'yyyy-mm-dd') - to_date(t_visit.visit_begin_admit_date_time,'yyyy-mm-dd')) as totalsleep
,sum(case when (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
    to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD')) = 0
           then 1
            else (to_date(substring(visit_staff_doctor_discharge_date_time,1,10),'YYYY-MM-DD') - 
    to_date(substring(t_visit.visit_begin_admit_date_time,1,10),'YYYY-MM-DD'))
    end) as จำนวนวันนอน

From t_visit
inner join t_patient
    ON t_patient.patient_hn = t_visit.visit_hn
INNER JOIN f_patient_prefix 
    ON f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id
inner join f_visit_ipd_discharge_type
    ON t_visit.f_visit_ipd_discharge_type_id = f_visit_ipd_discharge_type.f_visit_ipd_discharge_type_id
inner JOIN t_visit_payment
    ON t_visit.t_visit_id = t_visit_payment.t_visit_id
inner JOIN b_contract_plans
    ON t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
left join t_admit_leave_day 
    on t_visit.t_visit_id = t_admit_leave_day.t_visit_id

where 
--substr(t_visit.visit_ipd_discharge_date_time,1,10) between substring(?,1,10) and substring(?,1,10)
--substr(t_visit.visit_ipd_discharge_date_time,1,16) between '2558-10-01' and '2559-08-31'
 substr(visit_staff_doctor_discharge_date_time,1,10) between '2555-10-01' and '2556-09-30'
--substring(?,1,10) and substring(?,1,10)
 --(substr(visit_staff_doctor_discharge_date_time,1,10) Between '2557-09-01' and '2557-09-30')
AND t_visit.f_visit_type_id ='1'
and t_visit.f_visit_status_id <> '4'
and t_visit_payment.visit_payment_priority ='0'  -- สิทธิการรักษา ลำดับแรก
and t_visit_payment.visit_payment_active ='1'