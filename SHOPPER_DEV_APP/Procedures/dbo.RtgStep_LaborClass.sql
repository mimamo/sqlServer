USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_LaborClass]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgStep_LaborClass] @parm1 varchar ( 10) as
	Select * from RtgStep where LaborClassID = @parm1
		Order by kitid
GO
