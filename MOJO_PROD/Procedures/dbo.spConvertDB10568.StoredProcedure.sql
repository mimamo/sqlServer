USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10568]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10568]
AS
	
	--Delete any duplicates from tWebDavSecurity due to bug when copying files from one project to another
	DELETE tWebDavSecurity
	WHERE WebDavSecurityKey NOT IN
		(SELECT MIN(WebDavSecurityKey)
		FROM	tWebDavSecurity (nolock)
		GROUP BY CompanyKey, ProjectKey, Entity, EntityKey, Path)
GO
