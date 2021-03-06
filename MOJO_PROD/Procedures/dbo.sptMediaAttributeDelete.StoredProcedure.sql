USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaAttributeDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaAttributeDelete]
	@MediaAttributeKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/06/13  WDF 10.5.6.9 Created
*/

/*
    if exists(SELECT 1 from tCompanyMediaAttributeValue where MediaAttributeValueKey in (select MediaAttributeValueKey
                                                                                           from tMediaAttributeValue
                                                                                          where MediaAttributeKey = @MediaAttributeKey))
		Return -1
*/
	
	DELETE
	FROM tCompanyMediaAttributeValue
	where MediaAttributeValueKey in (select MediaAttributeValueKey
		from tMediaAttributeValue
		where MediaAttributeKey = @MediaAttributeKey)
		
	DELETE
	FROM tMediaAttributeValue
	WHERE MediaAttributeKey = @MediaAttributeKey


	DELETE
	FROM tMediaAttribute
	WHERE MediaAttributeKey = @MediaAttributeKey

	RETURN 1
GO
