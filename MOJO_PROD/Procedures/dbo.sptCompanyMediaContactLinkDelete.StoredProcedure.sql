USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContactLinkDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContactLinkDelete]
	@CompanyMediaKey int

AS --Encrypt

	DELETE
	FROM tCompanyMediaContact
	WHERE CompanyMediaKey = @CompanyMediaKey 

	RETURN 1
GO
