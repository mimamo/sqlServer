USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetDetails]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetDetails]
	(
	@LeadKey INT
	,@Table VARCHAR(25)
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 01/13/09 GHL 10.5	   Creation for multi details page
  ||                       Queries history on request only 
  || 05/18/09 MAS 10.5.0.0 Changed Stage to Left Outer join
  */
  
	SET NOCOUNT ON

   
IF @Table = 'tLevelHistory'   
   SELECT *
   FROM   tLevelHistory lh (NOLOCK)
   WHERE  EntityKey = @LeadKey and Entity = 'tLead'
   Order By LevelDate DESC
   
IF @Table = 'tLeadStageHistory'   
   SELECT lsh.*
          ,ls.LeadStageName
   FROM   tLeadStageHistory lsh (NOLOCK)
		Left Outer JOIN tLeadStage ls (NOLOCK) ON lsh.LeadStageKey = ls.LeadStageKey
   WHERE  lsh.LeadKey = @LeadKey
   Order By HistoryDate DESC
      
	
	RETURN 1
GO
