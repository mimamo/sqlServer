USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClassValidID]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptClassValidID]
	@CompanyKey int,
	@ClassNameOrID varchar(50)

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/13/12 MFT 10.557  Updated to allow name or ID validation
*/

DECLARE @ClassKey int

SELECT @ClassKey = ClassKey
FROM tClass (nolock)
WHERE
	CompanyKey = @CompanyKey AND
	ClassID = @ClassNameOrID

IF ISNULL(@ClassKey, 0) = 0
	SELECT @ClassKey = ClassKey
	FROM tClass (nolock)
	WHERE
		CompanyKey = @CompanyKey AND
		ClassName = @ClassNameOrID

RETURN ISNULL(@ClassKey, 0)
GO
