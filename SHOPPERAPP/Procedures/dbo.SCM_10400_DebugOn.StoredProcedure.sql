USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_DebugOn]    Script Date: 12/21/2015 16:13:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_DebugOn]
As
	Set	NoCount On
	Update	INSetup
		Set	S4Future10 = 1
	Print	'Debug has been turned on!'
GO
