--opd080จำนวนผู้ป่วยที่หมอตรวจรายวัน
SELECT 
DISTINCT q.แพทย์ที่ทำการตรวจ as รายชื่อ
--,q.id as id1
,"count"( q.ptid) as จำนวน
FROM
(
select DISTINCT t_patient.patient_hn as hn,
        t_visit.visit_vn AS AN,
        f_patient_prefix.patient_prefix_description || ' ' ||  t_patient.patient_firstname || ' ' ||  t_patient.patient_lastname as ชื่อสกุล,
       -- (substring(t_patient.patient_birthday,9,2) || '/' || substring(t_patient.patient_birthday,6,2) || '/' ||  substring(t_patient.patient_birthday,1,4)) AS วันเกิด,
--        t_visit.visit_financial_discharge_time as discharge,
      --  t_diag_icd10.diag_icd10_number as icd10,
        t_patient.patient_house as บ้านเลขที่,
        t_patient.patient_moo as หมู่,
        f1.address_description as ตำบล,
        f2.address_description as อำเภอ,
        f3.address_description as จังหวัด,
				b_service_point.service_point_description as จุดบริการ,
				b_employee.employee_firstname || ' ' || b_employee.employee_lastname as แพทย์ที่ทำการตรวจ,
				b_employee.b_employee_id as id,
				t_visit.visit_patient_self_doctor as ptid
from t_patient 
        INNER JOIN t_visit ON t_visit.t_patient_id = t_patient.t_patient_id 
				INNER JOIN b_employee on b_employee.b_employee_id=t_visit.visit_patient_self_doctor and b_employee.f_provider_type_id='000001'--แพทย์
        LEFT JOIN t_diag_icd10 ON t_diag_icd10.diag_icd10_vn = t_visit.t_visit_id  
        LEFT JOIN f_patient_prefix ON t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
        LEFT JOIN f_address as f1 ON t_patient.patient_tambon = f1.f_address_id
        LEFT JOIN f_address as f2 ON t_patient.patient_amphur =f2.f_address_id
        LEFT JOIN f_address as f3 ON t_patient.patient_changwat= f3.f_address_id 
        inner join t_visit_service on t_visit.t_visit_id = t_visit_service.t_visit_id and t_visit_service.b_service_point_id ='2060761082126' --02.OPD
				INNER JOIN b_service_point on b_service_point.b_service_point_id=t_visit_service.b_service_point_id
where t_visit.f_visit_status_id <> '4'  --ผู้ป่วยที่ไม่ถูกยกเลิกการเข้ารับบริการ
     --	t_diag_icd10.diag_icd10_number like 'I10%'
      --  and t_diag_icd10.f_diag_icd10_type_id = '1'  --primary 
        AND t_visit.f_visit_type_id = '0'
    and substring(t_visit.visit_begin_visit_time ,1,10) between substring('2560-03-10',1,10) and substring('2560-03-10',1,10)
    --and substring(t_visit.visit_begin_visit_time,1,10) between  substring(?,1,10) and substring(?,1,10)
--and b_employee.b_employee_id='157113540913344484'--นพ.ศรัณย์ พชรปกรณ์พงศ์

order by b_employee.b_employee_id--t_patient.patient_hn 
) as q
GROUP BY รายชื่อ