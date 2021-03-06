USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUserGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarUserGet]

	(
		@UserKey int,
		@CalendarUserKey int
	)

AS --Encrypt

Declare @Active tinyint
Declare @AccessType smallint
Declare @TimeZoneIndex int

Select @TimeZoneIndex = TimeZoneIndex from tUser (nolock) Where UserKey = @UserKey

If Exists(Select 1 from tUser (nolock) Where UserKey = @UserKey and Active = 1)
	Select @Active = 1
else
	Select @Active = 0

if @Active = 0
	Select @AccessType = 0
else
	Select @AccessType = AccessType from tCalendarUser (nolock) Where UserKey = @UserKey and CalendarUserKey = @CalendarUserKey

Select isnull(@AccessType, 0) as AccessType, @TimeZoneIndex as TimeZoneIndex
GO
