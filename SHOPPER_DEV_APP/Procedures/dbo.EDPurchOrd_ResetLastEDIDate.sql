USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurchOrd_ResetLastEDIDate]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPurchOrd_ResetLastEDIDate] @PONbr varchar(10) As
Update EDPurchOrd Set LastEDIDate = '01/01/1900' Where PONbr = @PONbr
GO
