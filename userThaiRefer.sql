SELECT 
employee_login as uid
,'1234' as pwd
,'user' as sect
,employee_firstname ||' '||employee_lastname as uname
 FROM b_employee
WHERE employee_active='1'