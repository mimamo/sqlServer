USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BMSetup_All]    Script Date: 12/21/2015 16:13:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMSetup_All] @SetupId varchar ( 2) as
	Select * from BMSetup where
		SetupId like @SetupId
		order by SetupId
GO
