SELECT DISTINCT
--b.b_item_id
b.item_common_name as รายการตรวจ
,b.item_general_number as รหัสกรมบัญชีการ
,bp.item_price as ราคาopd
,bp.item_price_ipd as ราคาipd
,bp.item_price_cost as ทุน
,b.r_rp1253_charitem_id as CHARGEITEM

FROM b_item b
INNER JOIN t_order t on b.b_item_id=t.b_item_id and t.f_order_status_id<>'3'
INNER JOIN b_item_price bp on bp.b_item_id=b.b_item_id
join 
(
SELECT b_item_id,max(item_price_active_date) as maxdate FROM b_item_price
GROUP BY b_item_id
) bip on bip.b_item_id=b.b_item_id and bip.maxdate=bp.item_price_active_date

INNER JOIN f_item_group fg on fg.f_item_group_id=t.f_item_group_id
--LEFT JOIN r_rp1253_charitem rc on rc.r_rp1253_charitem_id=b.r_rp1253_charitem_id
WHERE t.f_item_group_id='5'--**  1=ยา,2=LAB,3=X-Ray,4=เวชภัณฑ์,5=ค่าบริการ,6=ทันตกรรม  **
and b.item_active='1'

ORDER BY รายการตรวจ
--limit 10
