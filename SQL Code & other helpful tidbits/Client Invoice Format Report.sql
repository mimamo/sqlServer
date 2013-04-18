--client / project invoice format
select distinct c.CustId as 'Client'
, c.name 'Client Name'
, p.project as 'Job'
, p.project_desc as 'Job Desc'
, p.pm_id02 as 'Product'
, pc.code_value_desc as 'Product Description'
, b.inv_format_cd as 'Invoice Format'
from Customer c
LEFT OUTER JOIN PJPROJ p ON c.CustId = p.pm_id01
LEFT OUTER JOIN PJCODE pc ON p.pm_id02 = pc.code_value
LEFT OUTER JOIN PJBILL b ON p.project = b.project
where b.inv_format_cd <> ''
order by c.CustId, p.project, p.pm_id02, b.inv_format_cd

--determine which invoice formats we are using
select distinct inv_format_cd from PJBILL


--client invoice format
select distinct c.CustId as 'Client'
, c.name 'Client Name'
, p.pm_id02 as 'Product'
, pc.code_value_desc as 'Product Description'
, b.inv_format_cd as 'Invoice Format'
from Customer c
LEFT OUTER JOIN PJPROJ p ON c.CustId = p.pm_id01
LEFT OUTER JOIN PJCODE pc ON p.pm_id02 = pc.code_value
LEFT OUTER JOIN PJBILL b ON p.project = b.project
where b.inv_format_cd <> ''
order by c.CustId, p.pm_id02, b.inv_format_cd