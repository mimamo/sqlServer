USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListListDelete]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListListDelete]
	(
	@Entity	VARCHAR(25),
	@EntityKey INT,
	@UserKey INT = 0,
	@Application VARCHAR(25)
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 09/16/08  QMD 10.5.0.0 Initial Release
|| 03/26/10  QMD 10.5.2.0 Added Insert into MarketingListListDeleteLOg
*/

	IF EXISTS(SELECT 1 FROM tMarketingListList WHERE Entity = @Entity AND EntityKey = @EntityKey)
	  BEGIN
		
		-- Log Marketing List List Deletes
		DECLARE @parmList VARCHAR(50)
		SELECT @parmList = '@@EntityKey = ' + CONVERT(VARCHAR(10),@EntityKey)
		EXEC sptMarketingListListDeleteLogInsert @UserKey, @EntityKey, @Entity, 'sptMarketingListListDelete', @parmList, @Application
			
		DELETE	tMarketingListList				
		WHERE	Entity = @Entity
				AND EntityKey = @EntityKey

		IF (@@ERROR > 0)
			RETURN -1
	  END

	RETURN 1
GO
