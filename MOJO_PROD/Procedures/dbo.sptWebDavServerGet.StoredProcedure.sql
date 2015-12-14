USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavServerGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavServerGet]
	@WebDavServerKey int
AS
	
/*
|| When      Who Rel      What
|| 8/22/11   CRG 10.5.4.7 Created
*/

	SELECT	*
	FROM	tWebDavServer (nolock)
	WHERE	WebDavServerKey = @WebDavServerKey
GO
