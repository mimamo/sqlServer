USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalCompletedGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptApprovalCompletedGetList]
	
	 @ProjectKey int
	,@UserKey int
	
as -- Encrypt

	set nocount on
	
    select ap.*,UserKey
	  from tApproval ap (nolock) inner join tAssignment a (nolock) on ap.ProjectKey = a.ProjectKey
	 where ap.ProjectKey = @ProjectKey
       and a.UserKey = @UserKey
       and ap.Status = 2
  order by ap.DateCreated desc
  
	return 1
GO
