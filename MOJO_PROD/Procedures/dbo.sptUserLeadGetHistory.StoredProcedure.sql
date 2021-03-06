USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadGetHistory]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadGetHistory]
	(
		@UserLeadKey INT,
		@UserKey INT,
		@ViewOthers TINYINT
	)
	
AS
  /*
  || When     Who Rel       What
  || 07/28/08 QMD 10.5.0.0  Initial Release
  */

	SELECT 
		ca.ActivityKey AS EntityKey,
		'Activity' as Entity,
		CASE WHEN Completed = 1 THEN 'Open' ELSE 'Completed' END AS Stage,
		ActivityDate AS HistoryDate,
		u.FirstName + ' ' + u.LastName as AssignedUserName,
		ca.*
	FROM tActivity ca (NOLOCK)
		inner join tActivityLink al (NOLOCK) ON ca.ActivityKey = al.ActivityKey
		left outer join tUser u (NOLOCK) ON ca.AssignedUserKey = u.UserKey
	WHERE al.EntityKey = @UserLeadKey
			and al.Entity = 'tUserLead'
			and (@ViewOthers = 1 or AssignedUserKey = @UserKey)
GO
