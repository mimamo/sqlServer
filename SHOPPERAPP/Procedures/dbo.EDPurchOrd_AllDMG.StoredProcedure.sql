USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurchOrd_AllDMG]    Script Date: 12/21/2015 16:13:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPurchOrd_AllDMG] @PONbr varchar(10) As
Select * From EDPurchOrd Where PONbr = @PONbr
GO
