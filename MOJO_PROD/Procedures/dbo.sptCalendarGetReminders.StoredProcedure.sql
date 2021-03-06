USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetReminders]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetReminders]

	(
		@StartDate datetime,
		@EndDate datetime
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 1/20/10   CRG 10.5.1.7 (72888) Modified the ReminderTime restriction to allow records with ParentKey > 0.
||                        Otherwise, modified occurrences that have ReminderTime set to 0 were not being grabbed,
||                        which caused the Task Manager to send out reminders for the original meeting time.
||                        The Task Manager has been modified to not send an email out if the ReminderTime = 0.
*/

		SELECT	 c.*,
				convert(char(8), c.EventStart, 108) as StartTime
				,convert(char(8), c.EventEnd, 108) as EndTime				

				,ISNULL(u.FirstName+' ', '')+ISNULL(u.LastName, '') AS AuthorName
				,u.Email
				,u.TimeZoneIndex
				,cc.CompanyName
				,case When caddr.AddressKey is null then addr.Address1 else caddr.Address1 end as Address1
				,case When caddr.AddressKey is null then addr.Address2 else caddr.Address2 end as Address2
				,case When caddr.AddressKey is null then addr.Address3 else caddr.Address3 end as Address3
				,case When caddr.AddressKey is null then addr.City else caddr.City end as City
				,case When caddr.AddressKey is null then addr.State else caddr.State end as State
				,case When caddr.AddressKey is null then addr.PostalCode else caddr.PostalCode end as PostalCode
				,ISNULL(cu.Phone1, cc.Phone) as Phone
				,ISNULL(cu.FirstName, '') + ' ' + ISNULL(cu.LastName, '') as ContactName
				,p.ProjectNumber
				,p.ProjectName
		FROM tCalendar c (nolock)
			INNER JOIN tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey and ca.Entity = 'Organizer'
			INNER JOIN tUser org (nolock) ON ca.EntityKey = org.UserKey and ca.Entity = 'Organizer'
			INNER JOIN tCompany co (nolock) on c.CompanyKey = co.CompanyKey
			Left Outer Join tUser u (nolock) on ca.EntityKey = u.UserKey
			LEFT OUTER JOIN tCompany cc (nolock) on c.ContactCompanyKey = cc.CompanyKey
			LEFT OUTER JOIN tUser cu (nolock) on c.ContactUserKey = cu.UserKey
			LEFT OUTER JOIN tProject p (nolock) on c.ProjectKey = p.ProjectKey
			left outer join tAddress addr (nolock) on cc.DefaultAddressKey = addr.AddressKey
			left outer join tAddress caddr (nolock) on cu.AddressKey = caddr.AddressKey
		WHERE
			((DateAdd("n", -1 * c.ReminderTime, c.EventStart) > @StartDate and DateAdd("n", -1 * c.ReminderTime, c.EventStart) <= @EndDate ) or (c.Recurring =1 ) or (c.Deleted = 1) or (ParentKey > 0))
			and	org.Active = 1
			and (c.ReminderTime > 0 OR c.ParentKey > 0)
			and co.Locked = 0
GO
