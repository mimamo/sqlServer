USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeGetByID]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeGetByID]
	@CompanyKey int,
	@OfficeID varchar(50)

AS --Encrypt

		select @OfficeID = upper(ltrim(rtrim(@OfficeID)))

		SELECT *
		FROM tOffice (nolock)
		WHERE
			CompanyKey = @CompanyKey AND
			upper(OfficeID) = @OfficeID

	RETURN 1
GO
