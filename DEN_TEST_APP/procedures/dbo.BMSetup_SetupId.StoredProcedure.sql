USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMSetup_SetupId]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BMSetup_SetupId] @parm1 varchar ( 2) as
	Select * from BMSetup where
		SetupId like @parm1
		order by SetupId
GO
