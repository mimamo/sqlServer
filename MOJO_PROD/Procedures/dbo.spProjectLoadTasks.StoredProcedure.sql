USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadTasks]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadTasks]
	(
	@ProjectKey int
	)
AS

/*
|| When      Who Rel      What
|| 5/11/10   CRG 10.5.2.2 Added IconID to the select list
|| 1/10/11   CRG 10.5.4.0 Added ProjectNumber, ProjectName, TaskColor
|| 3/20/11   GWG 10.5.4.2 Added Open To Do Count
|| 3/10/14   RLB 10.5.7.8 (196273) 
*/

	select t.*
			,t.EstHours as EstimateHours
			,CASE WHEN t.TaskType = 2 THEN 'edit' 
				  WHEN t.TaskType = 1 THEN 
										case when t.AllowAllocatedHours = 1 then 'edit'
										else '' end
			 ELSE '' END AS IconID
			,(select count(*) from tForm f (nolock) 
			   Where f.TaskKey = t.TaskKey 
			   and	f.DateClosed IS NULL) as FormCount
			,ISNULL((Select Sum(ActualHours) from tTime ti (nolock) 
				   Where ti.ProjectKey = t.ProjectKey 
				   And ti.TaskKey = t.TaskKey), 0) as ActualHours
			,ISNULL((Select Sum(Hours) from tTaskUser tau (nolock) 
					   Where tau.TaskKey = t.TaskKey), 0) as AllocatedHours
			,(select count(*) from tAttachment (nolock)
			   Where AssociatedEntity = 'Task' AND
			   EntityKey = t.TaskKey) as AttachmentCount
			,ISNULL((Select Count(*) from tActivity (nolock) Where ActivityEntity = 'ToDo' and TaskKey = t.TaskKey and Completed = 0), 0) as ToDoCount
			,p.ProjectNumber
			,p.ProjectName
			,ts.SegmentColor AS TaskColor
   from tTask t (nolock)
   inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
   left join tTimelineSegment ts (nolock) ON t.TimelineSegmentKey = ts.TimelineSegmentKey
  where t.ProjectKey = @ProjectKey
  order by t.ProjectOrder
GO
