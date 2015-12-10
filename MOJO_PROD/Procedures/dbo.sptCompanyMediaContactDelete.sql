USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyMediaContactDelete]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyMediaContactDelete]
	@CompanyMediaKey int,
        @UserKey int

AS --Encrypt

	DELETE
	FROM tCompanyMediaContact
	WHERE CompanyMediaKey = @CompanyMediaKey
    AND UserKey = @UserKey


	RETURN 1
GO
