USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRSetup_UpdUsgCaptParms]    Script Date: 12/21/2015 13:35:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRSetup_UpdUsgCaptParms] @LastCalcDate SmallDateTime, @LastUserID VarChar(10) AS
	Update IRSetup set
		DemTranTime = getdate(),
		DemTranDate = @LastCalcDate,
		DemTranUserID = @LastUserID
GO
