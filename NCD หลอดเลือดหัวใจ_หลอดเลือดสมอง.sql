select
--'จน.ผู้ป่วย นอก CUP รพ.พังงา ' as รายการ
case  --when q.sub_hosp = '09083'  then  'รพ.สต.กะไหล'
     --when  q.sub_hosp = '09084'  then  'รพ.สต.เกาะกลาง' 
     --when  q.sub_hosp = '09085'  then  'รพ.สต.ท่าอยู่'
    -- when  q.sub_hosp = '09086'  then  'รพ.สต.บางหลาม' 
    -- when  q.sub_hosp = '09087'  then  'รพ.สต.หล่อยูง' 
    -- when  q.sub_hosp = '09088'  then  'รพ.สต.ทองหลาง'
    -- when  q.sub_hosp = '09089'  then  'รพ.สต.ท่านุ่น'
    -- when  q.sub_hosp = '09090'  then  'รพ.สต.คลองเคียน'
    -- when  q.sub_hosp = '09091'  then  'รพ.สต.อ่าวมะขาม'
     when  q.sub_hosp = '11354'  then  'รพ.ท้ายเหมือง'
   --  when  q.sub_hosp = ''  then  'หน่วยบริการอื่นๆ'

 end as หน่วยบริการ
,count(q.hn) as ครัง

--,sum (q.ค่ารักษารวม) as ค่ารักษารวม

from

(select
        b_site.b_visit_office_id as hcode
        ,t_visit.visit_vn as VN
        ,t_patient.patient_hn as HN
        ,t_patient.patient_pid as cid
        ,f_patient_prefix.patient_prefix_description as pname
        ,t_patient.patient_firstname as fname
        ,t_patient.patient_lastname as lname
        ,t_patient.patient_birthday as birthday
        ,t_patient.f_sex_id as sex
        ,Substring (t_visit.visit_begin_visit_time,1,10) as vstdate
        ,b_contract_plans.contract_plans_description as pttypename
        ,t_visit_payment.visit_payment_main_hospital as main_hosp
		,t_visit_payment.visit_payment_sub_hospital as sub_hosp
        ,t_billing.billing_total   AS ค่ารักษารวม
,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '1' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group1
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '2' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group2
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '3' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group3
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '4_OH' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group4
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '5' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group5
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '6' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group6
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '7' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group7
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '8' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group8
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = '9' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group9
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = 'A' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group10
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = 'B' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group11
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = 'C' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group12
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = 'D' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group13
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = 'E' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group14
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = 'F' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group15
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = 'G' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group16
   ,SUM(CASE WHEN TRIM(b_item_16_group.item_16_group_number) = 'H' 
         THEN t_billing_invoice_item.billing_invoice_item_total
         ELSE 0.00 
   END) AS group17
        
from
        t_visit inner join t_patient on t_patient.t_patient_id = t_visit.t_patient_id
        left join t_visit_payment on t_visit_payment.t_visit_id = t_visit.t_visit_id   and t_visit_payment.visit_payment_priority = '0' and t_visit_payment.visit_payment_active = '1'
        left join b_contract_plans on b_contract_plans.b_contract_plans_id = t_visit_payment.b_contract_plans_id 
inner join t_diag_icd10 on t_visit.t_visit_id = t_diag_icd10.diag_icd10_vn
inner join b_icd10 on t_diag_icd10.diag_icd10_number = b_icd10.icd10_number  


inner join t_death   on t_visit.t_visit_id = t_death.t_visit_id

        left join f_patient_prefix on f_patient_prefix.f_patient_prefix_id = t_patient.f_patient_prefix_id
        inner join t_billing_invoice_item on t_billing_invoice_item.t_visit_id = t_visit.t_visit_id and t_billing_invoice_item.billing_invoice_item_active = '1'
        inner join b_item on b_item.b_item_id = t_billing_invoice_item.b_item_id
        left join b_item_16_group on b_item_16_group.b_item_16_group_id = b_item.b_item_16_group_id
        left join t_billing ON t_visit.t_visit_id = t_billing.t_visit_id
        cross join b_site



where
        t_visit.f_visit_status_id <> '4'

     and t_death.death_active ='1' 
        and t_visit.f_visit_type_id ='0' 
        AND substring(t_diag_icd10.diag_icd10_number,1,5)  between 'I20.0' and 'I20.9' --หลอดเลือดหัวใจ
      --AND substring(t_diag_icd10.diag_icd10_number,1,5)  between 'I60.0' and 'I69.9' --หลอดเลือดหัวใจ
 

         and substr(t_visit.visit_begin_visit_time,1,10) between '2557-10-01' and '2558-09-30'
       -- and substr(t_visit.visit_begin_visit_time,1,10) between '2559-05-01' and '2559-05-31'
       -- and substr(t_visit.visit_begin_visit_time,1,10) between '2559-06-01' and '2559-06-30'


/*and  b_contract_plans.b_contract_plans_id not in ('212113498015154666','212113492877879656','0000000000000','212113493619813140',
'212113494434382460','212113494077088646','2120000000015','212113493409770265','2120000000026','212113491376156602','212113495633764035',
'212113497499896360','212113499479980463','212113498332681685','2120000000030','2120000000031','2120000000032','2120000000028','2120000000035',
'212113498810607245','212113491580440650','2120000000036','2120000000034','212113497648358045','2120000000067','2120000000068',
'2120000000070','2120000000071','2120000000072','2120000000073','212113495262018073','2120000000075','2120000000078') */--แก้ไขสิทธิ ไม่ใช่ สิทธิ UC ของโรงพยาบาลครับ   
      
    and
t_visit_payment.visit_payment_sub_hospital = '11354'
-- (t_visit_payment.visit_payment_sub_hospital = '09083'  -- 10739 พังงา
      --or t_visit_payment.visit_payment_sub_hospital = '09084'  --10740 ตะกั่วป่า,รพท.
      --or t_visit_payment.visit_payment_sub_hospital = '09085'  --11348 กะปง,รพช.
      --or t_visit_payment.visit_payment_sub_hospital = '09086'  --11347 เกาะยาว,รพช.
      --or t_visit_payment.visit_payment_sub_hospital = '09087'  --11353 ทับปุด,รพช.
      --or t_visit_payment.visit_payment_sub_hospital = '09088'  -- 11352 คุระบุรี,รพช.
      --or t_visit_payment.visit_payment_sub_hospital = '09089'  --11350 บางไทร,รพช.
      --or t_visit_payment.visit_payment_sub_hospital = '09090' --11354 ท้ายเหมือง
      --or t_visit_payment.visit_payment_sub_hospital = '09091' --11354 ท้ายเหมือง
      -- t_visit_payment.visit_payment_sub_hospital = '11354') --11349 ตะกั่วทุ่ง,รพช.
group by
        b_site.b_visit_office_id
        ,t_visit.visit_vn 
        ,t_patient.patient_hn 
        ,t_patient.patient_pid 
        ,f_patient_prefix.patient_prefix_description 
        ,t_patient.patient_firstname
        ,t_patient.patient_lastname 
        ,t_patient.patient_birthday 
        ,t_patient.f_sex_id 
        ,t_visit.visit_begin_visit_time 
        ,b_contract_plans.contract_plans_description 
        ,t_visit_payment.visit_payment_main_hospital
		,t_visit_payment.visit_payment_sub_hospital
        ,t_billing.billing_total  


) as q

 GROUP BY  q.sub_hosp

 ORDER  BY  q.sub_hosp

--select * from b_contract_plans

