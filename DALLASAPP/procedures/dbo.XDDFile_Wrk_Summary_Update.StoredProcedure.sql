USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Summary_Update]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Summary_Update]
   @RecordID		int

AS
   UPDATE	XDDFile_Wrk
   SET		RecordSummary = DepRecord
   WHERE	RecordID = @RecordID
GO
