USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLB_RecordID]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLB_RecordID]
	@RecordID	int
	
AS
	SELECT		*
	FROM		XDDBatchARLB (nolock)
	WHERE		RecordID = @RecordID
GO
