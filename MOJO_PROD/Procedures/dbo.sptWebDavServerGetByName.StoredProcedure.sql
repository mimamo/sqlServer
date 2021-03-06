USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavServerGetByName]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavServerGetByName]
	@Name varchar(200) --No CompanyKey, the Name must be unique in the entire table (it will be enforced on the setup screen)
AS

/*
|| When      Who Rel      What
|| 2/26/13   CRG 10.5.6.5 Created for use by the Mac WebDAV server
*/

	SELECT TOP 1 *
	FROM	tWebDavServer (nolock)
	WHERE	UPPER([Name]) = UPPER(@Name)
GO
