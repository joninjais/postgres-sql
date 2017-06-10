select t_visit.visit_locking
, t_visit.visit_staff_lock
, b_employee.employee_firstname ||' '|| b_employee.employee_lastname as employee
, b_employee.employee_active
from t_visit 
left join t_patient on t_patient.t_patient_id = t_visit.t_patient_id 
LEFT JOIN b_employee on b_employee.b_employee_id = t_visit.visit_staff_lock
where (f_visit_status_id like '3' or f_visit_status_id like '4') and visit_locking = '1' 
order by visit_begin_visit_time desc limit 500