USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMSetup_All]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMSetup_All] @SetupId varchar ( 2) as
	Select * from BMSetup where
		SetupId like @SetupId
		order by SetupId
GO
