USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_BMSetup]    Script Date: 12/21/2015 14:17:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_BMSetup]
As

	Select	*
		From	BMSetup (NoLock)
GO
