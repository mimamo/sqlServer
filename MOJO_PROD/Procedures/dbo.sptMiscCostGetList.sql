USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMiscCostGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMiscCostGetList]

	@ProjectKey int


AS --Encrypt

/*
|| When     Who Rel     What
|| 08/27/09 GHL 10.5    Added filter on TransferToKey NULL
|| 09/27/10 MFT 10.535  Added tItem, tDepartment, ClassName, Status
|| 06/22/11 RLB 10.545  (111726) added AddedBy
|| 04/06/14 RLB 10.580  Added new field for grouping in new app
|| 05/23/14 RLB 10.581  Added for IRM in New App
*/
	SELECT 
		tMiscCost.*, 
		tProject.ProjectName,
		tProject.ProjectNumber,
		tTask.TaskID, 
		tTask.TaskName,
		ISNULL(tTask.TaskName, 'No Task') as GroupTaskName,
		tItem.ItemID,
		tItem.ItemName,
		tClass.ClassID,
		tClass.ClassName,
		tDepartment.DepartmentName,
		ISNULL(tUser.FirstName, '') + ' ' + ISNULL(tUser.LastName, '') as AddedBy,
		CASE
			WHEN ISNULL(InvoiceLineKey, -1) = 0 THEN 'Marked as Billed'
			WHEN ISNULL(InvoiceLineKey, -1) > 0 THEN 'Billed'
			ELSE
				CASE ISNULL(WriteOff, 0)
					WHEN 0 THEN 'Unbilled'
					ELSE 'Written Off' END
			END +
			CASE
				WHEN ISNULL(WIPPostingInKey, 0) != 0 OR ISNULL(WIPPostingOutKey, 0) != 0 THEN ' Posted to WIP' ELSE ''
		END AS Status		
	FROM 
		tMiscCost (nolock)
		INNER JOIN tProject (nolock) ON tMiscCost.ProjectKey = tProject.ProjectKey 
		LEFT OUTER JOIN tTask (nolock) ON tMiscCost.TaskKey = tTask.TaskKey
		LEFT OUTER JOIN tClass (nolock) ON tMiscCost.ClassKey = tClass.ClassKey
		left outer join tItem (nolock) on tMiscCost.ItemKey = tItem.ItemKey
		left outer join tDepartment (nolock) on tMiscCost.DepartmentKey = tDepartment.DepartmentKey
		left outer join tUser (nolock) on tMiscCost.EnteredByKey = tUser.UserKey
	WHERE tMiscCost.ProjectKey = @ProjectKey
	AND   tMiscCost.TransferToKey IS NULL
	
	ORDER BY
		tMiscCost.ExpenseDate


	RETURN 1
GO
