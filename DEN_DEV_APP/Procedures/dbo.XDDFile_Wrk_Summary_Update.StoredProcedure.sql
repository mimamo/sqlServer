USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Summary_Update]    Script Date: 12/21/2015 14:06:26 ******/
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
