USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOINTran_RecordID]    Script Date: 12/21/2015 15:43:13 ******/
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
