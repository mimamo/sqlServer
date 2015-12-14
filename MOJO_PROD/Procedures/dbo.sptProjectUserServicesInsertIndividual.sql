USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUserServicesInsertIndividual]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUserServicesInsertIndividual]
	@ProjectKey int,
	@UserKey int,
	@ServiceKey int

AS --Encrypt

/*
|| When      Who Rel     What
|| 4/17/08   CRG 1.0.0.0 Created for WMJ Project Setup
*/

	IF NOT EXISTS
			(SELECT NULL
			FROM	tProjectUserServices (nolock)
			WHERE	ProjectKey = @ProjectKey
			AND		UserKey = @UserKey
			AND		ServiceKey = @ServiceKey)
		INSERT tProjectUserServices (ProjectKey, UserKey, ServiceKey)
		VALUES (@ProjectKey, @UserKey, @ServiceKey)
GO
