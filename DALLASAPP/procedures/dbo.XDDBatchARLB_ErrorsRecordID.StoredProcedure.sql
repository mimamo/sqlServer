USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLB_ErrorsRecordID]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLB_ErrorsRecordID]
	@RecordID	int
	
AS
	SELECT		*
	FROM		XDDBatchARLBErrors (nolock)
	WHERE		RecordID = @RecordID
GO
