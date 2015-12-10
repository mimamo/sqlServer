USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestGetByID]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestGetByID]
	@CompanyKey int,
	@RequestID varchar(50)
AS

/*
|| When      Who Rel      What
|| 10/9/08   CRG 10.0.1.0 (36981) Created to get the RequestKey from the ID
*/

	SELECT	*
	FROM	tRequest (nolock)
	WHERE	RequestID = @RequestID
	AND		CompanyKey = @CompanyKey
GO
