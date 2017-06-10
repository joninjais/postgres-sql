--OPD072-จำนวนผู้ป่วยโรคซึมเศร้า 5 โรคหลัก ตาม ICD10 F32,F33,F34.1,F38,F39
--OPD072-จำนวนผู้ป่วยโรคซึมเศร้า 5 โรคหลัก ตาม ICD10 F32,F33,F34.1,F38,F39
select  q1.icd10 AS ICD10
     ,count(visit_hn) as "ผู้ป่วยทั้งหมด(คน)"
     ,sum(new_patient_in_year) as "ผู้ป่วยใหม(คน)"
     ,sum(q1.men) as "ผู้ป่วยชาย(คน)"
     ,sum(q1.women) as "ผู้ป่วยหญิง(คน)"
     ,sum(q1.vn) as จำนวนครั้ง
from
(
select distinct t_visit.visit_hn,
count(t_visit.visit_vn) as vn
,t_diag_icd10.diag_icd10_number 
,case when (visit_first_visit ='1')
		then 1		else 0	end AS new_patient_in_year
,case when (t_patient.f_sex_id ='1')
		then 1		else 0	end AS men
,case when (t_patient.f_sex_id ='2')
		then 1		else 0 end  AS  women
  ,       case when (t_diag_icd10.diag_icd10_number = 'F32') THEN 'F32'  
                when (t_diag_icd10.diag_icd10_number = 'F33') THEN 'F33'  
                when (t_diag_icd10.diag_icd10_number = 'F34.1') THEN 'F34.1'  
                when (t_diag_icd10.diag_icd10_number = 'F38') THEN 'F38'  
                when (t_diag_icd10.diag_icd10_number = 'F39') THEN 'F39'                  
        ELSE '' END AS icd10 
       from  t_patient inner join t_visit on t_patient.t_patient_id = t_visit.t_patient_id
        INNER JOIN t_diag_icd10 ON t_diag_icd10.diag_icd10_vn = t_visit.t_visit_id             
inner join b_icd10 on t_diag_icd10.diag_icd10_number = b_icd10.icd10_number
where t_visit.f_visit_status_id <> '4' and f_visit_type_id  ='0'  
        AND t_diag_icd10.diag_icd10_number in ('F32','F33','F34.1','F38','F39')

              AND t_diag_icd10.diag_icd10_active ='1'
--       and substring(t_visit.visit_begin_visit_time ,1,10) between substring(?,1,10) and substring(?,1,10)
AND  substring(t_visit.visit_financial_discharge_time,0,11) Between'2552-10-01' and '2559-09-30'
group by 
t_visit.visit_hn
,t_diag_icd10.diag_icd10_number 
, new_patient_in_year
,men,women,icd10 
) AS q1
group by   q1.icd10 