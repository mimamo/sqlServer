USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectBillingStatusGetList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectBillingStatusGetList]

	@CompanyKey int,
	@ProjectBillingStatusKey int = NULL,	--Not NULL, include the Status value along with the Active ones (used on Project setup screen)
											-- -1, include all Status values regardless of Active flag (used on maintenance screen listing)
	@ProjectBillingStatusID varchar(30) = null
AS --Encrypt

/*
|| When      Who Rel     What
|| 5/1/07    CRG 8.5     (8991) Added @ProjectBillingStatusKey parameter.
|| 5/26/11   RLB 10544   Needed to change  SP to work with updates to Project Billing Statuses when importing them.
*/


IF ISNULL(@ProjectBillingStatusID, '') = ''
	SELECT	tProjectBillingStatus.*,
			ProjectBillingStatus as DisplayName
	FROM 	tProjectBillingStatus (NOLOCK) 
	WHERE	CompanyKey = @CompanyKey
	AND		(Active = 1 OR ProjectBillingStatusKey = @ProjectBillingStatusKey OR @ProjectBillingStatusKey = -1)
				
	ORDER BY Active DESC, DisplayOrder
ELSE
	SELECT *
	FROM 	tProjectBillingStatus (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey AND ProjectBillingStatusID = @ProjectBillingStatusID

	RETURN 1
GO
