USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeMasterTaskDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeMasterTaskDelete]
	(
		@ProjectTypeKey int
	)
AS --Encrypt

Delete tProjectTypeMasterTask Where ProjectTypeKey = @ProjectTypeKey
GO
