USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_LaborClass]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgStep_LaborClass] @parm1 varchar ( 10) as
	Select * from RtgStep where LaborClassID = @parm1
		Order by kitid
GO
