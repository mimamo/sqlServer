USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemValid]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemValid]
	@CompanyKey int,
	@ItemType smallint,
	@ItemNameOrID varchar(200)

AS --Encrypt

/*
|| When     Who Rel     What 
|| 06/13/12 MFT 10.557  Created
*/

DECLARE @ItemKey int

SELECT @ItemKey = ItemKey
FROM tItem (nolock)
WHERE
	CompanyKey = @CompanyKey AND
	ItemID = @ItemNameOrID AND
	ItemType = CASE WHEN @ItemType >= 0 THEN @ItemType ELSE ItemType END

IF ISNULL(@ItemKey, 0) = 0
	SELECT @ItemKey = ItemKey
	FROM tItem (nolock)
	WHERE
		CompanyKey = @CompanyKey AND
		ItemName = @ItemNameOrID AND
		ItemType = CASE WHEN @ItemType >= 0 THEN @ItemType ELSE ItemType END

RETURN ISNULL(@ItemKey, 0)
GO
