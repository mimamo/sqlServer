USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGetNotifyList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGetNotifyList]

AS --Encrypt

	SET NOCOUNT ON
		
	select rt.RecurTranKey 
	      ,u.CompanyKey
	      ,u.UserKey
	      ,u.FirstName + ' ' + u.LastName as UserName
	      ,u.Email
	from   tRecurTran rt (nolock)
	inner  join tCompany c (nolock) on rt.CompanyKey = c.CompanyKey
	inner  join tRecurTranUser rtu (nolock) on rt.RecurTranKey = rtu.RecurTranKey
	inner  join tUser u (nolock) on rtu.UserKey = u.UserKey
	Where  c.Active = 1
	and    c.Locked = 0
	and    rt.ReminderOption = 'Automatically Create' 
	and    (rt.NextDate is null OR rt.NextDate <= DATEADD(d, ISNULL(rt.DaysInAdvance, 0), GETDATE())) 
	and    rt.Active = 1 
	and    rt.NumberRemaining > 0
	and    u.Active = 1
		
	RETURN
GO
