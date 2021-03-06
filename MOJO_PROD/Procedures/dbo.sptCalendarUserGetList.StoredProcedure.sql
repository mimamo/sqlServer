USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUserGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarUserGetList]

	(
		@CompanyKey int,
		@UserKey int
	)

AS --Encrypt


Select 
	u.UserKey,
	u.FirstName,
	u.LastName,
	ISNULL((Select c.AccessType from tCalendarUser c (nolock) Where c.CalendarUserKey = u.UserKey and c.UserKey = @UserKey), 0) as AccessType
From
	tUser u (nolock)
Where
	u.CompanyKey = @CompanyKey and
	u.UserKey <> @UserKey and
	u.Active = 1
Order By u.LastName
GO
