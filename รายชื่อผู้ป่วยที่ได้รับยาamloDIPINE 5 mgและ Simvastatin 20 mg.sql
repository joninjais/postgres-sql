--รายชื่อผู้ป่วยที่ได้รับยาamloDIPINE 5 mgและ Simvastatin 20 mg
select t_visit.visit_begin_visit_time as วันรับบริการ
,t_patient.patient_hn AS HN 
,f_patient_prefix.patient_prefix_description || t_patient.patient_firstname || '  '  || t_patient.patient_lastname AS ชื่อผู้ป่วย
,t_patient.patient_birthday AS วันเดือนปีเกิด
,b1.item_common_name as รายการยา1
,t1.order_qty AS qty1
,i1.item_drug_instruction_description|| '  ' ||td1.order_drug_dose|| '  ' ||u1.item_drug_uom_description|| '    ' ||
f1.item_drug_frequency_description   as วิธีใช้1
,b2.item_common_name as รายการยา2
,t2.order_qty AS qty2
, i2.item_drug_instruction_description || '  ' ||td2.order_drug_dose  || '  ' ||u2.item_drug_uom_description || '    ' ||
 f2.item_drug_frequency_description as วิธีใช้2
 ,b_employee.employee_firstname AS ผู้ยืนยัน
,b_service_point.service_point_description as จุดบริการ
  ,case when t_visit.f_visit_type_id = '1' then 'IPD' else 'OPD' end as ประเภท
from t_order t1 inner join t_order t2 on t1.t_visit_id = t2.t_visit_id 
            inner join t_order_drug td1 on td1.t_order_id = t1.t_order_id
            inner join t_order_drug td2 on td2.t_order_id = t2.t_order_id
           LEFT JOIN b_service_point  ON t1.order_service_point = b_service_point.b_service_point_id
 LEFT JOIN b_employee  ON t1.order_staff_verify = b_employee.b_employee_id 
             inner join t_visit on t2 .t_visit_id = t_visit.t_visit_id -- AND t_visit.f_visit_type_id ='1'
            inner join b_item b1  on t1.b_item_id = b1.b_item_id
            inner join b_item b2  on t2.b_item_id = b2.b_item_id
            inner join t_patient on t_visit.t_patient_id = t_patient.t_patient_id
            left join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
inner join b_item_drug d1 on d1.b_item_id = b1.b_item_id
inner join b_item_drug  d2 on d2.b_item_id = b2.b_item_id
inner join b_item_drug_uom u1 on u1 .b_item_drug_uom_id = d1.item_drug_use_uom
inner join b_item_drug_uom u2 on u2.b_item_drug_uom_id = d2.item_drug_use_uom
inner join b_item_drug_instruction  i1 on i1 .b_item_drug_instruction_id =d1.b_item_drug_instruction_id
inner join b_item_drug_instruction i2 on i2 .b_item_drug_instruction_id =d2.b_item_drug_instruction_id
inner join b_item_drug_frequency f1 on f1.b_item_drug_frequency_id = d1.b_item_drug_frequency_id
inner join b_item_drug_frequency f2 on f2.b_item_drug_frequency_id = d2.b_item_drug_frequency_id

where  t1.b_item_id = '174113540813249923' --ยาตัวที่1 (174113540813249923,amloDIPINE 5 mg)
and t1.f_order_status_id not in ('0','3') 
and substring(t1.order_verify_date_time,1,10) between substring('2559-01-01',1,10) and substring('2559-01-31',1,10)
and t2.b_item_id = '174000003070011554' --ยาตัวที่ 2 (174000003070011554,Simvastatin 20 mg)
and t2.f_order_status_id not in ('0','3')
and substring(t2.order_verify_date_time,1,10) between substring('2559-01-01',1,10) and substring('2559-01-31',1,10) --ช่วงเวลาที่ต้องการ
group by วันรับบริการ ,HN ,ชื่อผู้ป่วย ,วันเดือนปีเกิด,รายการยา1, qty1,รายการยา2,qty2, วิธีใช้1,วิธีใช้2,ผู้ยืนยัน,จุดบริการ,ประเภท