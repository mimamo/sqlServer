USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptBillingScheduleGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptBillingScheduleGetList]

	@ProjectKey int
	
AS --Encrypt

  /*
  || When     Who Rel    What
  || 07/15/13 GHL 10.570 (182036) Added PercentBudget 
  ||                    
  */

	select bs.BillingScheduleKey
	      ,bs.NextBillDate
	      ,case when bs.NextBillDate is null then 0
	      else 1 end as DisplayOrder
	      ,bs.TaskKey
	      ,t.TaskID
	      ,t.TaskName
	      ,case 
			when t.TaskID is null then TaskName 
			else t.TaskID + ' ' + t.TaskName 
		   end as TaskFullName
	      ,bs.Comments
		  ,bs.PercentBudget
	      ,b.BillingID
	      ,@ProjectKey as ProjectKey
	  from tBillingSchedule bs (nolock) 
	       left outer join tTask t (nolock) on bs.TaskKey = t.TaskKey
	       left outer join tBilling b (nolock) on bs.BillingKey = b.BillingKey
	 where bs.ProjectKey = @ProjectKey
  order by DisplayOrder, bs.NextBillDate desc, TaskFullName
GO
