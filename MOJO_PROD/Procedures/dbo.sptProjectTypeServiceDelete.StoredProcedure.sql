USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeServiceDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeServiceDelete]
	(
		@ProjectTypeKey int
	)
AS --Encrypt

Delete tProjectTypeService Where ProjectTypeKey = @ProjectTypeKey
GO
