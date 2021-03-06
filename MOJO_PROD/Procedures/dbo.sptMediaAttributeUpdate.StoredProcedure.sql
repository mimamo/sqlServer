USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaAttributeUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaAttributeUpdate]
	 @MediaAttributeKey int
	,@CompanyKey int
	,@AttributeName varchar(1000)
	,@POKind smallint


AS --Encrypt
/*
|| When      Who Rel      What
|| 06/06/13  WDF 10.5.6.9 Created
*/
	
IF 	@MediaAttributeKey > 0
	BEGIN
		UPDATE tMediaAttribute
		   SET AttributeName = @AttributeName
		 WHERE MediaAttributeKey = @MediaAttributeKey

		RETURN @MediaAttributeKey

	END
ELSE
	BEGIN
		if exists(Select 1 from tMediaAttribute (nolock) Where CompanyKey = @CompanyKey and AttributeName = @AttributeName)
			Return -1

		INSERT tMediaAttribute
			(
			  CompanyKey
		     ,AttributeName
	         ,POKind
			)
		VALUES
			(
			  @CompanyKey
			 ,@AttributeName
			 ,@POKind
			)
		
		RETURN @@IDENTITY
	END
GO
