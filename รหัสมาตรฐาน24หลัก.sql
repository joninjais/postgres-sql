SELECT  
order_common_name AS ชื่อยา
,"รหัสมาตรฐาน24หลัก"
,sum(order_qty) AS จำนวน
,item_drug_uom_description AS หน่วย
,sum(price) AS มูลค่า
,sum(cost) as ต้นทุน


FROM 

(SELECT t_order.t_order_id 
,t_order.order_common_name AS order_common_name
,t_order.order_qty AS order_qty
,t_order.drugcode24 as "รหัสมาตรฐาน24หลัก"
,b_item_drug_uom.item_drug_uom_description AS item_drug_uom_description
, ceil(t_order.order_price * t_order.order_qty) AS price
,b_service_point.service_point_description AS service_point_description 
,ceil(to_number(t_order.order_cost,'99999999.99') * t_order.order_qty) AS cost
FROM b_item_drug_uom INNER JOIN  
(t_order_drug INNER JOIN ((t_order INNER JOIN b_employee ON t_order.order_staff_dispense = b_employee.b_employee_id )  
INNER JOIN b_service_point ON b_employee.b_service_point_id = b_service_point.b_service_point_id) 
ON t_order_drug.t_order_id = t_order.t_order_id AND(t_order.f_item_group_id = '1' OR t_order.f_item_group_id = '4') 
AND t_order.order_qty <> '0')  ON b_item_drug_uom.b_item_drug_uom_id = t_order_drug.b_item_drug_uom_id_purch 


WHERE  (t_order.f_order_status_id='5') 
AND (substring(t_order.order_dispense_date_time,1,16) Between '2557-10-01' and '2558-09-30')
 
GROUP BY t_order.t_order_id , t_order.order_common_name 
, t_order.order_qty, b_item_drug_uom.item_drug_uom_description 
, price
,cost
 , b_service_point.service_point_description) AS query1  
GROUP BY  order_common_name  
,item_drug_uom_description  
,service_point_description  
,"รหัสมาตรฐาน24หลัก"
--select * from t_order