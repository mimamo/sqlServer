USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAssignmentGetDefaultNotifiers]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAssignmentGetDefaultNotifiers] 
 @ProjectKey INT
  
AS --Encrypt  
  
    /*
  || When		Who Rel			What
  || 02/21/14	QMD 10.5.7.7	Created for new app to get default notifiers
  || 12/09/14   RLB 10.5.8.7    added for new app
  */

	SELECT	ass.UserKey, u.UserFullName AS UserName, u.Email, ass.UserKey as AssignedUserKey
	FROM	tAssignment ass (NOLOCK)
			INNER JOIN vUserName u (NOLOCK) ON ass.UserKey = u.UserKey
			INNER JOIN tUser (NOLOCK) ON u.UserKey = tUser.UserKey
	WHERE	ass.DeliverableNotify = 1
			AND ass.ProjectKey = @ProjectKey
	ORDER BY u.UserFullName
GO
