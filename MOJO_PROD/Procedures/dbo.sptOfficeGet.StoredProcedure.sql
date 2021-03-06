USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeGet]
	@OfficeKey int = null,
	@OfficeID varchar(50) = null,
	@CompanyKey int = null

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/26/11   RLB 10544	 Needed to change  SP to work with updates to Offices when importing them.
*/

IF ISNULL(@OfficeKey, 0) = 0
	Select *
	from tOffice (nolock)
	Where 
		CompanyKey = @CompanyKey and OfficeID = @OfficeID
ELSE
	SELECT *
	FROM tOffice (nolock)
	WHERE
		OfficeKey = @OfficeKey

	RETURN @OfficeKey
GO
