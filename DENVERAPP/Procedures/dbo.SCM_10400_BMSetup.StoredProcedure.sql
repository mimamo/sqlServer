USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_BMSetup]    Script Date: 12/21/2015 15:43:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_BMSetup]
As

	Select	*
		From	BMSetup (NoLock)
GO
