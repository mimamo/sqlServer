USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOINTran_RecordID]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOINTran_RecordID]
	@RecordID		  int

AS
	SELECT           *
	FROM             INTran
	WHERE            RecordID = @RecordID
GO
