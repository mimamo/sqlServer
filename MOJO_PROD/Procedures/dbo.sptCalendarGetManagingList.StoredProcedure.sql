USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetManagingList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetManagingList]

	(
		@UserKey int
	)

AS --Encrypt


Select 
	u.UserKey,
	u.FirstName + ' ' + u.LastName as UserName
From
	tUser u (nolock) inner join
	tCalendarUser c (nolock) on u.UserKey = c.UserKey
Where
	c.CalendarUserKey = @UserKey and
	c.AccessType = 2 and 
	u.Active = 1
Order By u.LastName
GO
