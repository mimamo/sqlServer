USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMobileMenuGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMobileMenuGetList]


AS --Encrypt

/*
|| When     Who Rel			What
|| 01/14/11 MAS 10.5.?.?	Created
*/

SELECT     
	 *
FROM         
	tMobileMenu (nolock)

ORDER BY DefaultDisplayOrder
GO
