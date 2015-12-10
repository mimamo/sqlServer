USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10508]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10508]
AS

/*
|| When      Who Rel      What
|| 8/21/09   GWG 10.5.0.8 Added a right to edit activities
*/





exec spConvertDBSeed

INSERT INTO [tRightAssigned] ([EntityType],[EntityKey],[RightKey]) 
	Select 'Security Group', EntityKey, 931507 From tRightAssigned Where RightKey = 931500 and EntityKey > 0 and EntityKey not in (Select EntityKey from tRightAssigned Where RightKey = 931507)
GO
