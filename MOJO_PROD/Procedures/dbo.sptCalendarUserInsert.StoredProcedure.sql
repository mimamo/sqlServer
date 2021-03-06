USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUserInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarUserInsert]

	(
		@UserKey int,
		@CalendarUserKey int,
		@AccessType smallint
	)

AS --Encrypt

if exists(Select 1 from tCalendarUser (nolock) Where UserKey = @UserKey and CalendarUserKey = @CalendarUserKey)
Update tCalendarUser
	Set AccessType = @AccessType
Where
	UserKey = @UserKey and CalendarUserKey = @CalendarUserKey
	
else
	Insert tCalendarUser
		(
		UserKey,
		CalendarUserKey,
		AccessType
		)
		Values
		(
		@UserKey,
		@CalendarUserKey,
		@AccessType
		)
GO
