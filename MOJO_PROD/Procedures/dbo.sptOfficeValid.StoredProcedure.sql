USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeValid]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeValid]
	@CompanyKey int,
	@OfficeNameOrID varchar(200)

AS --Encrypt

DECLARE @key int

SELECT @key = OfficeKey
FROM tOffice (nolock)
WHERE
	CompanyKey = @CompanyKey AND
	OfficeID = @OfficeNameOrID

IF ISNULL(@key, 0) = 0
	SELECT @key = OfficeKey
	FROM tOffice (nolock)
	WHERE
		CompanyKey = @CompanyKey AND
		OfficeName = @OfficeNameOrID

SELECT *
FROM tOffice (nolock)
WHERE OfficeKey = @key
GO
