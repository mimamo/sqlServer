USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10540]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10540]
AS
	SET NOCOUNT ON

	update tRequestDef
	set DisplayProjectFields = 1
	where DisplayProjectFields is null
	
	update tRequestDef
	set RequireProjectName = 0 
	where RequireProjectName is null

	RETURN 1
GO
