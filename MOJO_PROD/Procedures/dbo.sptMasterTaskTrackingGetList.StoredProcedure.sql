USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskTrackingGetList]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskTrackingGetList]

	@MasterTaskKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/05/07 GHL 8.4   Added restriction on SummaryMasterTaskKey and TaskType to prevent from 
  ||                    picking up erroneous master tasks from other companies                      
  */
		SELECT tm.*
		FROM   tMasterTask tm (NOLOCK)
		WHERE  tm.SummaryMasterTaskKey = @MasterTaskKey
		AND    tm.SummaryMasterTaskKey > 0
		AND    tm.TaskType = 2
		
		ORDER BY WorkOrder
		
	RETURN 1
GO
