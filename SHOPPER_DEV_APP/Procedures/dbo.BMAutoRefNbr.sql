USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMAutoRefNbr]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BMAutoRefNbr] as
	Select LastRefNbr from BMSetup
	order by SetupId
GO
