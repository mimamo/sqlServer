USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurchOrd_Open]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPurchOrd_Open] @Parm1 varchar(15) As
Select *
From PurchOrd A
	left outer join EDPurchOrd B
		on A.PONbr = B.PONbr
Where A.VendId = @Parm1
	And A.Status Not In ('X','M')
GO
