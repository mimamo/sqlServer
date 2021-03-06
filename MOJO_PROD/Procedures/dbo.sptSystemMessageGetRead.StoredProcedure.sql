USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSystemMessageGetRead]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSystemMessageGetRead]

	(
		@UserKey int
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 4/13/11   GWG 10.542   Added in the plain message text
*/

Select ISNULL(PlainMessageText, MessageText) as MessageText, DateViewed
From
	tSystemMessage sm (nolock)
	inner join tSystemMessageUser smu (nolock) on sm.SystemMessageKey = smu.SystemMessageKey
	
Where
	UserKey = @UserKey
order by smu.DateViewed DESC, sm.SystemMessageKey DESC
GO
