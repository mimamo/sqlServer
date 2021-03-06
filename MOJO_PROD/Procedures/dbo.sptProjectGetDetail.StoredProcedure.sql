USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetDetail]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectGetDetail]

	(
		@ProjectKey int
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 11/30/06 GHL 8.4   Added ScheduleLockedByName to show on Flash screen 
  ||                    
  */

	SELECT 
		* 
		,(Select FirstName + ' ' + LastName from tUser (nolock) where tProject.ScheduleLockedByKey = tUser.UserKey) as ScheduleLockedByName
	FROM 
		tProject (NOLOCK) 
	WHERE
		ProjectKey = @ProjectKey
GO
