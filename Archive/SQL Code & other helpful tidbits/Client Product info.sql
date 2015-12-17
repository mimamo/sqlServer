select * from xIGProdCode

select c.CustId, Name as CustName, pjd.Product, pc.descr as ProdDescr from Customer c join 
xProdJobDefault pjd on c.CustId = pjd.CustID join xIGProdCode pc on pjd.Product = pc.code_ID