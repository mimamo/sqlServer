USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetReminders]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetReminders]
	@StartDate datetime,
	@EndDate datetime
AS

/*
|| When      Who Rel      What
|| 6/10/09   CRG 10.5.0.0 Created for the Task Manager to send out reminders for Activities
|| 7/2/09    CRG 10.5.0.0 Removed reference to tActivity.TimeZoneIndex
|| 3/10/11   RLB 10.5.4.2 (102000) pulling 15 ahead for reminders in the 2 week range and protected against Calendar reminder being null
|| 05/16/13  MFT 10.5.6.8 (178488) Added u.OwnerCompanyKey, u.UserID, u.ClientVendorLogin to filter for staff only in the result set
|| 06/24/13  RLB 10.5.6.9 (181697) Added some Active user protection
|| 09/26/13  RLB 10.5.7.2 (191286) only pull not completed activities
|| 02/18/15  CRG 10.5.8.9 (246486) The StartTime and EndTime are not necessarily the same date as the ActivityDate. 
||                        Modified the query to merge the start and end times with the ActivityDate for use by the TaskManager reminder process
||                        so that reminders are not sent out on the wrong date.
*/

	SELECT	a.ActivityKey,
			a.CompanyKey,
			u.TimeZoneIndex,
			0 AS Deleted,
			a.ReminderMinutes AS ReminderTime,
			0 AS Recurring,
			DATEADD(MI, DATEPART(MI, ISNULL(a.StartTime, a.ActivityDate)), DATEADD(HH, DATEPART(HH, ISNULL(a.StartTime, a.ActivityDate)), a.ActivityDate)) AS EventStart,
			DATEADD(MI, DATEPART(MI, ISNULL(a.EndTime, DATEADD(hh, 24, a.ActivityDate))), DATEADD(HH, DATEPART(HH, ISNULL(a.EndTime, DATEADD(hh, 24, a.ActivityDate))), a.ActivityDate)) AS EventEnd,
			a.Subject,
			u.Email,
			LTRIM(RTRIM(ISNULL(FirstName,'') + ' ' + ISNULL(LastName,''))) AS AuthorName,
			u.FirstName,
			u.LastName,
			u.OwnerCompanyKey,
			u.UserID,
			u.ClientVendorLogin,
			NULL AS Location,
			Notes AS Description,
			p.ProjectNumber,
			p.ProjectName,
			c.CompanyName,
			con.UserName AS ContactName,
			ISNULL(con.Phone1, c.Phone) AS Phone,
			CASE WHEN caddr.AddressKey IS NULL THEN addr.Address1 ELSE caddr.Address1 END AS Address1,
			CASE WHEN caddr.AddressKey IS NULL THEN addr.Address2 ELSE caddr.Address2 END AS Address2,
			CASE WHEN caddr.AddressKey IS NULL THEN addr.Address3 ELSE caddr.Address3 END AS Address3,
			CASE WHEN caddr.AddressKey IS NULL THEN addr.City ELSE caddr.City END AS City,
			CASE WHEN caddr.AddressKey IS NULL THEN addr.State ELSE caddr.State END AS State,
			CASE WHEN caddr.AddressKey IS NULL THEN addr.PostalCode ELSE caddr.PostalCode END AS PostalCode,
			CASE WHEN a.StartTime IS NULL THEN 1 ELSE 0 END AS AllDayEvent 
	FROM	tActivity a (nolock)
	INNER JOIN tUser u (nolock) ON a.AssignedUserKey = u.UserKey
	LEFT JOIN tProject p (nolock) ON a.ProjectKey = p.ProjectKey
	LEFT JOIN tCompany c (nolock) ON a.ContactCompanyKey = c.CompanyKey
	LEFT JOIN vUserName con (nolock) ON a.ContactKey = con.UserKey
	LEFT JOIN tAddress addr (nolock) ON c.DefaultAddressKey = addr.AddressKey
	LEFT JOIN tAddress caddr (nolock) ON con.AddressKey = caddr.AddressKey
	WHERE	a.ActivityDate IS NOT NULL
	AND		a.AssignedUserKey IS NOT NULL
	AND     u.Active = 1 -- only active for active assigned users
	AND     a.Completed = 0 -- only activities that are not completed
	AND		a.ReminderMinutes > 0 --Only activities that are set for a reminder
	AND		ISNULL(u.CalendarReminder, 0) IN (0, 1) --Only people who want an email reminder
	--Get a 15 day forward and 1 back of activities because or reminder minutes and convert them based on the Assigned User's time zone in VB
	AND		a.ActivityDate >= DATEADD(d, -1, @StartDate)
	AND		a.ActivityDate <= DATEADD(d, 15, @EndDate)
GO
