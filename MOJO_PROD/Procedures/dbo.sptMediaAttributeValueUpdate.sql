USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaAttributeValueUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaAttributeValueUpdate]
	 @MediaAttributeValueKey int
	,@MediaAttributeKey int
	,@ValueName varchar(1000)


AS --Encrypt
/*
|| When      Who Rel      What
|| 06/06/13  WDF 10.5.6.9 Created
*/

IF 	@MediaAttributeValueKey > 0
	BEGIN
	
		if @ValueName is null
		BEGIN
			exec sptMediaAttributeValueDelete @MediaAttributeValueKey
			return 1
		END
	
		UPDATE tMediaAttributeValue
		SET ValueName = @ValueName
		WHERE MediaAttributeValueKey = @MediaAttributeValueKey

		RETURN @MediaAttributeValueKey

	END
ELSE
	BEGIN
			
		if @ValueName is null
			return 1
			
		INSERT tMediaAttributeValue
			(
			  MediaAttributeKey
		     ,ValueName
			)
		VALUES
			(
	          @MediaAttributeKey
	         ,@ValueName
			)
		
		RETURN @@IDENTITY
	END
GO
