USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Summary_Update]    Script Date: 12/16/2015 15:55:38 ******/
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
