SELECT distinct(b_item.item_number)
,b_item.item_common_name
,b_item_service.icd9_number || ' : ' || b_icd9.icd9_description as ICD9
--,b_icd9.icd9_description


from b_item_service 
INNER JOIN b_item on b_item_service.b_item_id = b_item.b_item_id
INNER JOIN b_item_subgroup on b_item.b_item_subgroup_id = b_item_subgroup.b_item_subgroup_id

left JOIN b_icd9 on b_icd9.icd9_number = b_item_service.icd9_number

where b_item_service.item_service_active = '1'
and b_item_subgroup.f_item_group_id = '6'