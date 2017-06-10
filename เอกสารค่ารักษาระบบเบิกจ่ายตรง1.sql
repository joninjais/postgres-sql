select
    q.hospital
    ,q.d_visit
    ,q.pt_age
    ,q.HN
    ,q.VN
    ,q.pt_type
    ,q.PID
    ,q.pt_name
    ,q.plan
    ,q.address
    ,q.item16group
    ,q.b_item_id
    ,q.item_common_name
    ,q.item_nick_name
    ,q.draw
    ,q.discharge
    ,q.visit
    ,sum(q.order_qty) as order_qty
    ,q.order_price
    ,sum(q.sum_order) as sum_order
    ,sum(q.draw_price) as draw_price
    ,sum(q.no_draw) as no_draw
from
        (select
        site_full_name as hospital 
        ,cast(cast(substring("t_visit"."visit_begin_visit_time",1,4) as numeric) -543 
                || substring("t_visit"."visit_begin_visit_time",5,6) as DATE)  as d_visit
        ,t_visit.visit_patient_age as pt_age
        ,t_patient.patient_hn as HN
        ,t_visit.visit_vn as VN
        ,case when t_visit.f_visit_type_id ='0' then 'ผู้ป่วยนอก'
         when t_visit.f_visit_type_id ='1' then 'ผู้ป่วยใน'
         Else 'ไม่ระบุ' end as pt_type
        ,t_patient.patient_pid as PID
        ,f_patient_prefix.patient_prefix_description 
         || ' ' || t_patient.patient_firstname 
         || ' ' || t_patient.patient_lastname as pt_name
        ,b_contract_plans.contract_plans_description as plan
        ,t_patient.patient_house 
         || ' หมู่ ' || t_patient.patient_moo
         || ' ถนน' || t_patient.patient_road 
         || ' ตำบล' || tambon.address_description
         || ' อำเภอ' || amphur.address_description 
         || ' จังหวัด' || changwat.address_description as address
        ,case when (b_item.b_item_16_group_id = '3120000000003' and t_visit.f_visit_type_id = '1' and t_order.order_home = '1')
        then 'ยาที่นำกลับบ้าน' else b_item_16_group.item_16_group_description end as item16group
        --,item_billing_subgroup_description as    item16group
        --,item_billing_subgroup_description  as billing_subgroup
        ,t_order.t_order_id
        ,t_order.b_item_id
        ,case when b_item_subgroup.f_item_group_id ='1' then b_item.item_common_name||'  ('||b_nhso_drugcode24.drugcode24 || ')'
            else b_item.item_common_name end as item_common_name
        ,b_item.item_nick_name
        ,case when t_billing_invoice_item.billing_invoice_item_draw = '1' then '(เบิกได้)'
            else '(เบิกไม่ได้)' end as draw
        ,cast(t_order.order_qty as numeric) as order_qty
        ,ceil(t_order.order_price) as order_price
        ,ceil(t_order.order_qty*t_order.order_price) as sum_order
        ,case when t_billing_invoice_item.billing_invoice_item_draw = '1' then t_billing_invoice_item.billing_invoice_item_total
            else '0' end as draw_price
        --,t_billing_invoice_item.billing_invoice_item_total as draw_price
        ,case when t_billing_invoice_item.billing_invoice_item_draw = '1' then '0'
            else t_billing_invoice_item.billing_invoice_item_total end as no_draw
        ,t_visit.visit_staff_doctor_discharge_date_time as discharge
        ,t_visit.visit_begin_admit_date_time as visit
        --,billing_receipt_billing_subgroup_paid as patient_share
        --,billing_receipt_billing_subgroup_draw as draw

        from t_patient 
        left join t_visit on t_patient.t_patient_id = t_visit.t_patient_id and t_visit.f_visit_status_id<>'4'
        left join t_visit_payment on t_visit.t_visit_id =t_visit_payment.t_visit_id and t_visit_payment.visit_payment_priority ='0' and t_visit_payment.visit_payment_active='1'
        left join b_contract_plans on  t_visit_payment.b_contract_plans_id = b_contract_plans.b_contract_plans_id
        left join f_patient_prefix on t_patient.f_patient_prefix_id = f_patient_prefix.f_patient_prefix_id
        left join (select * from f_address) as changwat on changwat.f_address_id = t_patient.patient_changwat
        left join (select * from f_address) as amphur on amphur.f_address_id = t_patient.patient_amphur
        left join (select * from f_address) as tambon on tambon.f_address_id = t_patient.patient_tambon
        left join (select * from f_address) as changwat_ct on changwat_ct.f_address_id = t_patient.patient_changwat
        left join (select * from f_address) as amphur_ct on amphur_ct.f_address_id = t_patient.patient_amphur
        left join (select * from f_address) as tambon_ct on tambon_ct.f_address_id = t_patient.patient_tambon
        left join t_patient_personal_disease on t_patient_personal_disease.t_patient_id = t_patient.t_patient_id
        left join f_patient_relation on f_patient_relation.f_patient_relation_id = t_patient.f_patient_relation_id
        left join t_order on t_visit.t_visit_id = t_order.t_visit_id
        left join b_item on t_order.b_item_id = b_item.b_item_id
        left join b_item_16_group on b_item.b_item_16_group_id = b_item_16_group.b_item_16_group_id
        left join b_item_subgroup on b_item.b_item_subgroup_id = b_item_subgroup.b_item_subgroup_id
        left join t_billing_invoice_billing_subgroup on t_billing_invoice_billing_subgroup.t_visit_id = t_visit.t_visit_id 
        left join b_nhso_map_drug on b_item.b_item_id = b_nhso_map_drug.b_item_id
        left join b_nhso_drugcode24 on b_nhso_drugcode24.b_nhso_drugcode24_id = b_nhso_map_drug.b_nhso_drugcode24_id
        --left join t_billing_invoice_billing_subgroup on t_order.b_item_billing_subgroup_id = t_billing_invoice_billing_subgroup.b_item_billing_subgroup_id)

        left join t_billing_invoice_item on (t_visit.t_visit_id = t_billing_invoice_item.t_visit_id and t_order.t_order_id = t_billing_invoice_item.t_order_item_id)
        --left join t_billing_receipt_billing_subgroup on (t_billing_receipt_billing_subgroup.t_visit_id = t_visit.t_visit_id and t_order.b_item_billing_subgroup_id = t_billing_receipt_billing_subgroup.b_item_billing_subgroup_id)
        --left join b_item_billing_subgroup on b_item_billing_subgroup.b_item_billing_subgroup_id = t_billing_receipt_billing_subgroup.b_item_billing_subgroup_id

        --left join t_billing_receipt_billing_subgroup on t_billing_receipt_billing_subgroup.t_visit_id = t_visit.t_visit_id

        CROSS JOIN  b_site
        where --t_visit.t_visit_id = $P{visit_id} --'255112045865156515'
						t_visit.t_visit_id = '255113542488135775'
        and t_order.f_order_status_id <> '3'
        and t_billing_invoice_item.billing_invoice_item_active = '1'
        --and t_order.b_item_billing_subgroup_id = t_billing_receipt_billing_subgroup.b_item_billing_subgroup_id
        --and b_item_16_group.b_item_16_group_id not in ('3120000000003','3120000000004','3120000000005')
        --and b_contract_plans.b_contract_plans_id in ('212114048215010775','212114048437229911','212114045576486151','2120000000001','212114041433859389','2120000000002')
        group by hospital,d_visit,pt_age,HN,VN,PID,pt_name,plan,address
        --,item16group
        ,t_order.b_item_id
        ,b_item.item_common_name ,b_item.item_nick_name,t_order.order_price,pt_type,t_order.order_qty
        ,t_billing_invoice_item.billing_invoice_item_draw
        ,t_billing_invoice_item.billing_invoice_item_total
        ,b_item_16_group.item_16_group_number
        ,b_item_16_group.item_16_group_description
        ,b_item.b_item_16_group_id
        ,t_order.t_order_id
        ,t_visit.f_visit_type_id
        ,t_order.order_home
        ,b_item_subgroup.f_item_group_id
        ,b_nhso_drugcode24.drugcode24
	,t_visit.visit_staff_doctor_discharge_date_time 
        ,t_visit.visit_begin_admit_date_time
        --,t_billing_receipt_billing_subgroup.billing_receipt_billing_subgroup_paid
        --,t_billing_receipt_billing_subgroup.billing_receipt_billing_subgroup_draw
        --,b_item_billing_subgroup.item_billing_subgroup_description
        ) as q
group by q.hospital
    ,q.d_visit
    ,q.pt_age
    ,q.HN
    ,q.VN
    ,q.pt_type
    ,q.PID
    ,q.pt_name
    ,q.plan
    ,q.address
    ,q.item16group
    ,q.b_item_id
    ,q.item_common_name
    ,q.item_nick_name
    ,q.draw
    ,q.discharge
    ,q.visit
    ,q.order_price
order by  item16group