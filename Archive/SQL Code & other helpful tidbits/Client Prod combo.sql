USE [MIDWESTAPP]
GO

-- Gets the customer and product combos
select x.CustID, c.name as cust_name, x.Product, p.descr as prod_desc from xProdJobDefault x 
left outer join Customer c on x.CustID = c.CustId left outer join 
xIGProdCode p on x.Product = p.code_ID 

-- Gets the Vendor information
select * from Vendor

-- gets the gl accounts and sub accounts
USE [DENVERSYS]
GO
select acct as GL_Acct, Descr as GL_Descr, Sub from acctsub where CpnyID = 'midwest'