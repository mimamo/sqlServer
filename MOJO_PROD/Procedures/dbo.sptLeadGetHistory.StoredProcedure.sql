USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetHistory]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetHistory]
	@LeadKey int,
	@UserKey int,
	@ViewOthers tinyint
AS --Encrypt

  /*
  || When     Who Rel      What
  || 01/14/09 GHL 10.5	Reading now vListing_Activity vs vListing_ContactActivity
  */
	SELECT	ActivityKey AS EntityKey,
			'Activity' AS Entity,
			Status AS Stage,
			[Activity Date] AS HistoryDate,
			[Oportunity Subject] AS Subject,
			[Assigned To] AS AssignedUserName,
			[Project Number] + '-' + [Project Name] AS ProjectFullName,
			[Oportunity Subject] AS Subject,
			[Activity Notes] AS Notes
	FROM	vListing_Activity (nolock) 
	WHERE	LeadKey = @LeadKey
	AND		(AssignedUserKey = @UserKey OR @ViewOthers = 1)
	
	SELECT	CalendarKey AS EntityKey,
			'Meeting' as Entity, 
			case When [Calendar End Time] >= GETUTCDATE() then 'Open' else 'Completed' end as Stage,
			[Calendar Subject] AS Subject,
			[Author Name] AS Organizer,
			[Calendar Location] AS Location,
			[Calendar Start Time] as HistoryDate,
			[Calendar Start Time] AS EventStart,
			[Calendar End Time] AS EventEnd,
			[Calendar Description] AS Description,
			[Company Name] AS ContactCompany,
			[Contact Name] AS ContactName,
			[Contact Phone 1] AS Phone1,
			[Contact Cell] AS Cell,
			[Contact Email] AS Email
	FROM	vListing_Event (nolock) 
	WHERE	ContactLeadKey = @LeadKey
GO
