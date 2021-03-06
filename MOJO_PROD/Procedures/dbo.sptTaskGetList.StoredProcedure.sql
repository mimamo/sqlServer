USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetList]
	@ProjectKey int
AS --Encrypt

  /*
  || When     Who Rel   What
  || 11/13/06 GHL 8.4   Added AttachmentCount to show on Flash UI
  || 12/15/07 GHL 8.5   Added ProjectKey to join with tTime
  ||                    
  */

	select t.*
		  ,t.EstHours as EstimateHours
		  ,(select count(*) from tForm f (nolock) 
			Where f.TaskKey = t.TaskKey and f.DateClosed IS NULL)		as FormCount
	      ,ISNULL((Select Sum(ActualHours) from tTime ti (nolock) 
			Where ti.ProjectKey = t.ProjectKey And ti.TaskKey = t.TaskKey), 0)							as ActualHours
	      ,ISNULL((Select Sum(Hours) from tTaskUser tau (nolock) 
			Where tau.TaskKey = t.TaskKey), 0)							as AllocatedHours
		  ,(select count(*) from tAttachment (nolock)
			Where AssociatedEntity = 'Task' AND
			EntityKey = t.TaskKey)										as AttachmentCount
	  from tTask t (nolock)
	 where t.ProjectKey = @ProjectKey
  order by t.ProjectOrder

	return 1
GO
