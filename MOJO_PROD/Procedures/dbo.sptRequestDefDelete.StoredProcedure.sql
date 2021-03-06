USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefDelete]
	@RequestDefKey int

AS --Encrypt

if exists(select 1 from tRequest (NOLOCK) Where RequestDefKey = @RequestDefKey)
	return -1
	
	DELETE
	FROM tRequestDefSpec 
	WHERE
		RequestDefKey = @RequestDefKey 

	DELETE
	FROM tRequestDef
	WHERE
		RequestDefKey = @RequestDefKey 

	RETURN 1
GO
