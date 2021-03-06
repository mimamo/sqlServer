USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttachmentGetByPath]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttachmentGetByPath]
	@Path varchar(2000), --Path includes Entity/EntityKey, so it will be unique and not overlap with other companies.
	@CompanyKey int = NULL --Added optional CompanyKey parm to help with search speed
AS

/*
|| When      Who Rel      What
|| 8/10/12   CRG 10.5.5.8 Created
|| 12/3/12   CRG 10.5.6.2 Added optional CompanyKey parm to help with search speed now that CompanyKey has been added to the tAttachment table
*/

	SELECT	*
	FROM	tAttachment (nolock)
	WHERE	(CompanyKey = @CompanyKey OR @CompanyKey IS NULL)
	AND		UPPER(Path) = UPPER(@Path)
GO
