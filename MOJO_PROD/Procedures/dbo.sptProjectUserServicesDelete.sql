USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUserServicesDelete]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUserServicesDelete]
	@ProjectKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 4/17/08   CRG 1.0.0.0 Created for WMJ Project Setup
*/

	DELETE	tProjectUserServices 
	WHERE	ProjectKey = @ProjectKey
GO
