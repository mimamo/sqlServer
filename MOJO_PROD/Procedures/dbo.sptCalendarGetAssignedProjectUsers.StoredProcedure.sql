USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetAssignedProjectUsers]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetAssignedProjectUsers]
  @CalendarKey int

AS --Encrypt
 select us.UserKey
       ,c.CompanyName + ' / ' +us.FirstName + ' ' + us.LastName as UserName
       ,us.LastName
       ,us.FirstName
       ,us.Email
       ,ag.HourlyRate
   from tUser       us (nolock)
       ,tAssignment ag (nolock)
       ,tCompany    c  (nolock)
  where ag.ProjectKey = (select ProjectKey from tCalendar (nolock) where CalendarKey = @CalendarKey)
    and ag.UserKey = us.UserKey
    and us.Active = 1
    and us.CompanyKey = c.CompanyKey
    and us.UserKey not in (select EntityKey from tCalendarAttendee (nolock)
		where CalendarKey = @CalendarKey and Entity <> 'Resource' and Entity <> 'Group')
    order by us.FirstName, us.LastName
    
 return  1
GO
