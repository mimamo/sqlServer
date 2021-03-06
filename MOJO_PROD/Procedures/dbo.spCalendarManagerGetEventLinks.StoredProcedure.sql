USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetEventLinks]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetEventLinks]
	@CalendarKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/23/08   CRG 10.5.0.0 Created for the Calendar Manager
*/

	SELECT	'Project' as Type, 
			Entity,
			EntityKey,
			p.ProjectNumber + ' ' + p.ProjectName as LinkDescription
	FROM	tCalendarLink l (nolock) 
	INNER JOIN tProject p (nolock) on l.EntityKey = p.ProjectKey
	WHERE	CalendarKey = @CalendarKey
	AND		Entity = 'tProject'

	UNION
	
	SELECT	'Company' as Type, 
			Entity,
			EntityKey,
			c.CompanyName
	FROM	tCalendarLink l (nolock) 
	INNER JOIN tCompany c (nolock) on l.EntityKey = c.CompanyKey
	WHERE	CalendarKey = @CalendarKey
	AND		Entity = 'tCompany'
	
	UNION
	
	SELECT	'Opportunity' as Type, 
			Entity,
			EntityKey,
			ld.Subject
	FROM	tCalendarLink l (nolock) 
	INNER JOIN tLead ld (nolock) on l.EntityKey = ld.LeadKey
	WHERE	CalendarKey = @CalendarKey
	AND		Entity = 'tLead'
GO
