USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_DebugOff]    Script Date: 12/21/2015 13:35:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_DebugOff]
As
	Set	NoCount On
	Update	INSetup
		Set	S4Future10 = 0
	Print	'Debug has been turned off!'
GO
