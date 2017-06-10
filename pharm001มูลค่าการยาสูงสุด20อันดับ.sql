--pharm001มูลค่าการยาสูงสุด20อันดับ
select --q1.b_item_id,
         q1.item_common_name
        ,sum(q1.order_qty) as จำนวนที่ใช้	
				,q1.order_price as ราคาขาย
				,cast(q1.item_price_cost as decimal(8,2))::text as ราคาทุน
        ,sum(q1.total_price) as มูลค่าขาย
				,cast(sum(q1.fund) as decimal(8,2))::text as มูลค่าทุน
from(
select DISTINCT t_visit.t_visit_id
,t_visit.visit_vn
,b_item.b_item_id
,b_item.item_common_name as item_common_name
,t_order.order_price as order_price
,bp.item_price_cost as item_price_cost
,t_order.order_qty as order_qty
,bp.item_price_cost*t_order.order_qty as fund
,t_order.order_price*t_order.order_qty as total_price
,t_order.order_date_time as order_date_time
from t_visit 
            LEFT JOIN t_order ON  t_visit.t_visit_id = t_order.t_visit_id and t_order.f_order_status_id<>'3' and  t_order.f_item_group_id ='1' 
            INNER JOIN b_item ON t_order.b_item_id = b_item.b_item_id 
						INNER JOIN b_item_price bp on bp.b_item_id=b_item.b_item_id
join 
(
SELECT b_item_id,max(item_price_active_date) as maxdate FROM b_item_price
GROUP BY b_item_id
) bip on bip.b_item_id=b_item.b_item_id and bip.maxdate=bp.item_price_active_date
						
where 
--and t_order.b_item_id ='174113540813249923'
 substring(t_visit.visit_begin_visit_time,1,10) BETWEEN substring('2559-10-01',1,10) AND substring('2559-10-05',1,10)
--AND substring(t_visit.visit_begin_visit_time,1,10) BETWEEN substring(?,1,10) AND substring(?,1,10)
--and b_item.item_common_name like 'ยาอมแก้เจ็บคอ'
) as q1 
group by q1.b_item_id,q1.item_common_name,ราคาขาย,ราคาทุน
order by มูลค่าขาย  desc
limit 20