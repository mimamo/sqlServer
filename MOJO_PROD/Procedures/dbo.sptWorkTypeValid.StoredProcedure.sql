USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWorkTypeValid]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWorkTypeValid]
	@CompanyKey int,
	@WorkTypeNameOrID varchar(200)
AS --Encrypt

/*
|| When     Who Rel     What
|| 06/13/12 MFT 10.557  Created
*/

DECLARE @key int

SELECT @key = WorkTypeKey
FROM tWorkType (nolock)
WHERE
	WorkTypeID = @WorkTypeNameOrID AND
	CompanyKey = @CompanyKey

IF @key IS NULL
	SELECT @key = WorkTypeKey
	FROM tWorkType (nolock)
	WHERE
		WorkTypeName = @WorkTypeNameOrID AND
		CompanyKey = @CompanyKey

SELECT *
FROM tWorkType (nolock)
WHERE WorkTypeKey = @key
GO
