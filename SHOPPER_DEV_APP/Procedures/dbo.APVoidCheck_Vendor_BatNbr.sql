USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APVoidCheck_Vendor_BatNbr]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APVoidCheck_Vendor_BatNbr] @parm1 varchar ( 10) As
Select *
from APDoc
	left outer join Vendor
		on APDoc.VendId = Vendor.VendId
Where APDoc.BatNbr = @parm1
And APDoc.DocType <> 'SC'
Order By APDoc.BatNbr, APDoc.RefNbr
GO
