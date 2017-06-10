--UPDATE t_visit_refer_in_out set record_date_time='2559-05-14,22:00:45',refer_date='2559-05-14',refer_time='00:45'
--WHERE t_visit_id='255113543791631443'

--UPDATE t_visit_refer_in_out set visit_refer_in_out_active='1'
--WHERE t_visit_refer_in_out_id='226113541734683139'


SELECT
--t.t_visit_id,
rf.t_visit_refer_in_out_id,
rf.t_visit_id,
rf.visit_refer_in_out_number,
rf.record_date_time,
rf.refer_date,
rf.refer_time,
rf.visit_refer_in_out_result_date,
rf.visit_refer_in_out_active,
--rf.visit_refer_in_out_staff_doctor_report,

--rf.visit_refer_in_out_staff_report,
rf.visit_refer_in_out_vn,
rf.visit_refer_in_out_hn,
rf.visit_refer_in_out_status,
rf.visit_refer_in_out_staff_doctor_refer,
rf.visit_refer_in_out_staff_refer,
--rf.f_refer_result_id,
rf.refer_result
--rf.refer_care_date,
--rf.refer_care_time
FROM t_visit t
INNER JOIN t_visit_refer_in_out rf on t.t_visit_id=rf.t_visit_id
WHERE 
t.visit_vn='060012715'
--rf.visit_refer_in_out_number='OU5902324'

