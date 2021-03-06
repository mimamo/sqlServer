USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingScheduleGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingScheduleGet]

	@BillingScheduleKey int

AS --Encrypt

		select bs.*
				,case 
					when t.TaskID is null then TaskName 
					else t.TaskID + ' ' + t.TaskName 
				end as TaskFullName
				,b.BillingID
				,p.ProjectNumber
		  from tBillingSchedule bs (nolock) 
		       inner join tProject p (nolock) on bs.ProjectKey = p.ProjectKey
		       left outer join tTask t (nolock) on bs.TaskKey = t.TaskKey
	           left outer join tBilling b (nolock) on bs.BillingKey = b.BillingKey
	     where bs.BillingScheduleKey = @BillingScheduleKey


	return 1
GO
