USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10570]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10570]
As
	SET NOCOUNT ON

	-- convert PO and POD MC fields
	exec spConvertMC

	-- (Issue 184557) add new right purch_approvecreditcardcharge (60403)
	-- for anyone that has the purch_usecreditcardconnect right (60500)
	Insert tRightAssigned (EntityType, EntityKey, RightKey)
	Select EntityType, EntityKey, 60403 from tRightAssigned Where RightKey = 60500

	RETURN
GO
