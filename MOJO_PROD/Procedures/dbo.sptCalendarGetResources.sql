USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetResources]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetResources]

	(
		@CompanyKey int,
		@CalendarKey int,
		@Type smallint,
		@SearchPhrase as varchar(100),	
		@OrganizerKey int,
		@SearchOption as int = 0 
	)

AS --Encrypt

	Select
		CalendarResourceKey,
		ResourceName

	
	from tCalendarResource (nolock)
	Where 
		CompanyKey = @CompanyKey and

		CalendarResourceKey not in (select EntityKey from tCalendarAttendee (nolock) where CalendarKey = @CalendarKey and Entity = 'Resource')			
			
		and
				
		ResourceName like @SearchPhrase+'%'
	
Order By ResourceName
GO
