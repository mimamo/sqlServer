USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10509]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10509]
AS

/*
|| When      Who Rel      What
|| 9/9/09   GWG 10.5.0.9 Added a right to edit activities for clients
*/





exec spConvertDBSeed

INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) 
	Select 'Security Group', EntityKey, 501710 From tRightAssigned Where RightKey = 501700 and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 501710)


exec spConvertDBRefreshViews
GO
