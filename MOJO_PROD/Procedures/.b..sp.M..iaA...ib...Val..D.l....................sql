USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaAttributeValueDelete]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaAttributeValueDelete]
	@MediaAttributeValueKey int

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/06/13  WDF 10.5.6.9 Created
*/

/*
    if exists(SELECT 1 from tCompanyMediaAttributeValue where MediaAttributeValueKey = @MediaAttributeValueKey)
		Return -1
*/

	DELETE
	FROM tCompanyMediaAttributeValue
	WHERE MediaAttributeValueKey = @MediaAttributeValueKey
	
	DELETE
	FROM tMediaAttributeValue
	WHERE MediaAttributeValueKey = @MediaAttributeValueKey


	RETURN 1
GO
