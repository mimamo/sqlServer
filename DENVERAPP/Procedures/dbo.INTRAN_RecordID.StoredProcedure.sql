USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[INTRAN_RecordID]    Script Date: 12/21/2015 15:42:56 ******/
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
