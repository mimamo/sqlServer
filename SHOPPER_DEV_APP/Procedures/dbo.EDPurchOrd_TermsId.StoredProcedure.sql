USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurchOrd_TermsId]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPurchOrd_TermsId] @PONbr varchar(10) As
Select Terms From PurchOrd Where PONBr = @PONbr
GO
