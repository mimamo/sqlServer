USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Log]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  View [dbo].[vListing_Log]

as

/*
|| When     Who Rel      What
|| 7/27/10  RLB 10.5.3.3 (86201) fixed so data was pulled on the day it was entered on the month view
|| 9/05/12  RLB 10.5.6.0 (153402) change fields to correctly display date
*/


Select
	al.CompanyKey,
	al.ProjectKey,
	Entity, 
	EntityKey,
	Entity as [System Section],
	Action,
	ActionDate as [Action Date],
	Cast(Cast(Month(ActionDate) as varchar) + '/' + Cast(Day(ActionDate) as varchar) + '/' + Cast(Year(ActionDate) as varchar) as smalldatetime) as [ActionDateNoTime],
	ActionDate as [Action Time],
	ActionBy as [Action By],
	Comments,
	Reference,
	SourceCompanyID as [Source Company ID],
	p.ProjectNumber as [Project Number],
	p.ProjectName as [Project Name]
From
	tActionLog al (nolock)
	left outer join tProject p (nolock) on al.ProjectKey = p.ProjectKey
Where
	Entity <> 'FileVersion'
GO
