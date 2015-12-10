USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLabBetaInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLabBetaInsert]
	@CompanyKey int,
	@LabKey int = NULL
AS

/*
|| When      Who Rel      What
|| 4/26/10   CRG 10.5.2.1 Created for use by the About window to enable betas for a company
|| 02/09/11  MFT 10.5.4.1 Added @LabKey - Inserts all on NULL or just @LabKey
*/

	INSERT	tLabBeta
			(LabKey,
			CompanyKey)
	SELECT	LabKey,
			@CompanyKey
	FROM	tLab (nolock)
	WHERE	Beta = 1
			AND LabKey NOT IN (SELECT LabKey FROM tLabBeta (nolock) WHERE CompanyKey = @CompanyKey)
			AND LabKey = ISNULL(@LabKey, LabKey)
GO
