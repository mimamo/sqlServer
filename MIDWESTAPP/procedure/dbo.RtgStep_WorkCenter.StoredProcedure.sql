USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_WorkCenter]    Script Date: 12/21/2015 15:55:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[RtgStep_WorkCenter] @parm1 varchar ( 10) as
	Select * from RtgStep where WorkCenterID = @parm1
	Order by kitid
GO
