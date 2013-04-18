select top 10 * 
from x01621 x 
left outer join Vendor v on x.GLVendID = v.VendId
left outer join Customer c on x.ClientID = c.CustId
left outer join xIGProdCode p on x.ProductID = p.code_ID