USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vp_DecPrc]    Script Date: 12/21/2015 15:55:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vp_DecPrc]
AS
	Select	COALESCE((Select DecPl From Currncy Where CuryID = GLSetup.BaseCuryID), INSetup.DecPlPrcCst) As DecPlPrcCst,
		INSetup.DecPlQty
		From	INSetup, GLSetup
GO
