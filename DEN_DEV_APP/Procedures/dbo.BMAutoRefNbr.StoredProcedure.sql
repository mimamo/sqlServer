USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMAutoRefNbr]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BMAutoRefNbr] as
	Select LastRefNbr from BMSetup
	order by SetupId
GO
