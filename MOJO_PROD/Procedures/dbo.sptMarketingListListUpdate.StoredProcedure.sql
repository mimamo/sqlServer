USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMarketingListListUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMarketingListListUpdate]
	@MarketingListKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Selected tinyint,
	@UserKey int = 0

AS --Encrypt

  /*
  || When     Who Rel       What
  || 10/01/09 GHL 10.511   (63702) Added DateAdded for Business Dev Report       
  || 03/02/10 QMD 10.5.1.9  Added UserKey and insert into the delete log table
  */

DECLARE @DateAdded smalldatetime
SELECT @DateAdded = CONVERT(smalldatetime,  CONVERT(VARCHAR(10), GETDATE(), 101), 101)
	
if @Selected = 1
BEGIN
	IF NOT EXISTS(
		SELECT 1 FROM tMarketingListList (NOLOCK)
		WHERE MarketingListKey = @MarketingListKey AND Entity = @Entity AND EntityKey = @EntityKey)

		INSERT tMarketingListList
			(
			MarketingListKey,
			Entity,
			EntityKey,
			DateAdded
			)

		VALUES
			(
			@MarketingListKey,
			@Entity,
			@EntityKey,
			@DateAdded
			)
END
ELSE
BEGIN

	DECLARE @parmList VARCHAR(50)
	SELECT @parmList = '@EntityKey = ' + CONVERT(VARCHAR(10),@EntityKey)
    EXEC sptMarketingListListDeleteLogInsert @UserKey, @EntityKey, @Entity, 'sptMarketingListListUpdate', @parmList, 'UI'

	DELETE tMarketingListList WHERE MarketingListKey = @MarketingListKey AND Entity = @Entity AND EntityKey = @EntityKey

END

RETURN 1
GO
