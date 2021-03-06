USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingEditTimeGet]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingEditTimeGet]

	@TimeKey uniqueidentifier,
	@BillingKey int
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 3/9/07   CRG 8.4.0.7 Added BillingKey parameter to restrict the Billing Detail record since TimeKey is not always unique in the table.
*/
	  
	select t.*
	      ,ta.TaskID
	      ,ta.TaskID + ' ' + ta.TaskName as TaskFullName
	      ,ta.TaskName
	      ,p.ProjectNumber
	      ,p.ProjectName
	      ,p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName
	      ,u.FirstName + ' ' + u.LastName as UserName
	      ,isnull(bd.Comments,t.Comments) as BillingComments
	      ,bd.Quantity as BillingHours
	      ,bd.Rate as BillingRate
	      ,bd.Total as BillingTotal
	      ,bd.WriteOffReasonKey as BillingWriteOffReasonKey
	      ,bd.ServiceKey as BillingServiceKey
	      ,bd.RateLevel as BillingRateLevel
	      ,bd.EditComments
	  from tTime t (nolock) left outer join tTask ta (nolock) on t.TaskKey = ta.TaskKey
	       left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	       inner join tUser u (nolock) on t.UserKey = u.UserKey
	       inner join tBillingDetail bd (nolock) on t.TimeKey = bd.EntityGuid and bd.BillingKey = @BillingKey
	 where TimeKey = @TimeKey
	
	
	return 1
GO
