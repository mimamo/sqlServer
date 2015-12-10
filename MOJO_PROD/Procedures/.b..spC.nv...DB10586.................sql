USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10586]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10586]

AS
	SET NOCOUNT ON

	update tPreference set AllowTransferDate = 1
	
	-- 236371 - Update script for tRightAssigned to add users that have the old right.
	INSERT INTO tRightAssigned (EntityType, EntityKey, RightKey)
	SELECT 'Security Group', EntityKey, 10115
	FROM tRightAssigned 
	WHERE RightKey = 10102

	RETURN 1
GO
