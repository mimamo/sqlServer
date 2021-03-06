USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemValidID]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemValidID]

	(
		@CompanyKey int,
		@ItemType smallint,
		@ItemID varchar(50)
	)

AS --Encrypt

  /*
  || When     Who Rel       What 
  || 03/12/08 BSH 8.5.0.6   (22898)Check for Active Items.
  */

Declare @ItemKey int

if @ItemType = -1
	Select @ItemKey = ItemKey
	From tItem (nolock)
	Where
		CompanyKey = @CompanyKey and
		ItemID = @ItemID
		and Active = 1
else
	Select @ItemKey = ItemKey
	From tItem (nolock)
	Where
		CompanyKey = @CompanyKey and
		ItemType = @ItemType and
		ItemID = @ItemID and Active = 1
	
	
Return ISNULL(@ItemKey, 0)
GO
