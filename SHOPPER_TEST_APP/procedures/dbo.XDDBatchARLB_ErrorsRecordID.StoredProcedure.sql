USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLB_ErrorsRecordID]    Script Date: 12/21/2015 16:07:24 ******/
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
