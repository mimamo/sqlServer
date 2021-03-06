USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCreateInvoiceTree]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCreateInvoiceTree]

AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/28/06 GHL 8.4   Added TrackBudget in task temp tables
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description
  */

declare @MissingParents int

	select @MissingParents = isnull(count(*),0)
	  from #tInvcTask
	 where SummaryTaskKey not in (select TaskKey from #tInvcTask)
	   and SummaryTaskKey <> 0
	if @MissingParents > 0 
	  begin

	    insert #tInvcTask
		select distinct ta.TaskKey
		      ,ta.SummaryTaskKey
		      ,ta.TaskType
		      ,ta.DisplayOrder
		      ,isnull(ta.Taxable, 0)
		      ,isnull(ta.Taxable2, 0)
		      ,ta.WorkTypeKey
		      ,ta.TrackBudget
		      ,ta.TaskName
		      ,case when isnull(ta.ShowDescOnEst, 0) = 0 then null
		            else ta.Description  
		      end
		  from #tInvcTask w
		      ,tTask ta (nolock)		      
		 where w.SummaryTaskKey = ta.TaskKey
		   and ta.TaskKey not in (select TaskKey from #tInvcTask)
		   and w.SummaryTaskKey <> 0
      
	    exec spCreateInvoiceTree
	    
	  end 
	                       
	return 1
GO
