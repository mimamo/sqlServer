USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectBillingStatusValid]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectBillingStatusValid]
	@CompanyKey int,
	@ProjectBillingStatusID varchar(30)
AS

/*
|| When      Who Rel      What
|| 5/27/11   CRG 10.5.4.4 Created
*/

	DECLARE	@ProjectBillingStatusKey int

	SELECT	@ProjectBillingStatusKey = ProjectBillingStatusKey
	FROM	tProjectBillingStatus (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		UPPER(ProjectBillingStatusID) = UPPER(@ProjectBillingStatusID)

	RETURN ISNULL(@ProjectBillingStatusKey, 0)
GO
