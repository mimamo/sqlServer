select Name, * from Customer where Name = 'CARHARTT'

select * from PJCODE where code_value = 'IGG'

select * from xIGProdCode 

select * from xProdJobDefault where Product = 'carg'

select * from xProductGrouping where ProductId = 'cola'

-- with Class ID
select c.ClassId, cc.Descr, c.custid, c.name,pc.code_group, pc.code_ID, pc.descr, pc.status
from xProdJobDefault jd 
LEFT OUTER JOIN Customer c ON jd.CustID = c.CustId 
left outer join CustClass cc ON c.ClassId = cc.ClassId
left outer join xIGProdCode pc on jd.Product = pc.code_ID
where pc.status = 'A'
order by c.Name

--just customer and products
select c.custid, c.name,pc.code_group, pc.code_ID, pc.descr, pc.status
from xProdJobDefault jd 
LEFT OUTER JOIN Customer c ON jd.CustID = c.CustId 
left outer join xIGProdCode pc on jd.Product = pc.code_ID
where pc.status = 'A'
order by c.Name

