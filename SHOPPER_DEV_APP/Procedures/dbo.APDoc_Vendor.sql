USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Vendor]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APDoc_Vendor] @parm1 varchar ( 15) as
Select *
from APDoc
	left outer join Vendor
		on APDoc.VendId = Vendor.VendId
Where
APDoc.BatNbr = @parm1 and
APDoc.Rlsed = 0
Order by APDoc.BatNbr, APDoc.RefNbr
GO
