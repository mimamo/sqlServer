USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeGetByName]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeGetByName]
	@CompanyKey int,
	@OfficeName varchar(200)

AS --Encrypt

		SELECT *
		FROM tOffice (nolock)
		WHERE
			CompanyKey = @CompanyKey AND
			OfficeName = @OfficeName

	RETURN 1
GO
