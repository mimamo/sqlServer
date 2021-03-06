USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSystemMessageGetReadWMJ]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSystemMessageGetReadWMJ]

	(
		@UserKey int
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 06/06/11  RLB 10.545   created for the flex myinfo page
*/

Select PlainMessageText as MessageText, DateViewed
From
	tSystemMessage sm (nolock)
	inner join tSystemMessageUser smu (nolock) on sm.SystemMessageKey = smu.SystemMessageKey
	
Where
	UserKey = @UserKey and PlainMessageText Is not Null
order by smu.DateViewed DESC, sm.SystemMessageKey DESC
GO
