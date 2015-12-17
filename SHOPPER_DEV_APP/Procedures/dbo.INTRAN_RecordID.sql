USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTRAN_RecordID]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[INTRAN_RecordID]
	@RecordID	Integer
As
	Select	*
		From	INTran (NoLock)
		Where	RecordID = @RecordID
GO
