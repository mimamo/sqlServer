USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10581]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10581]

AS
	SET NOCOUNT ON

	-- Add the right prjQuickAddTask to anyone who has the right prjEditTasks	
	INSERT INTO tRightAssigned (EntityType, EntityKey, RightKey)  
	SELECT EntityType, EntityKey, 90935 FROM tRightAssigned WHERE RightKey = 90320
	
	-- Add the right prjQuickAddActivities to anyone who has the right useActivities
	INSERT INTO tRightAssigned (EntityType, EntityKey, RightKey)  
	SELECT EntityType, EntityKey, 90936 FROM tRightAssigned WHERE RightKey = 931500
		
	RETURN
GO
