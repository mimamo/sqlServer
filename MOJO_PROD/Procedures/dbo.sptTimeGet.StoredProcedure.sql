USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeGet]
 @TimeKey uniqueidentifier
AS --Encrypt

/*
|| When      Who Rel      What
|| 04/23/13  GHL 10.5.6.7	(167212) Added Service Code for flex lookups
*/

  SELECT t.*, 
	ta.TaskID, 
	ta.TaskID + ' ' + ta.TaskName as TaskFullName,
	ta.TaskName,
	p.ProjectNumber, 
	p.ProjectName,
	p.ProjectNumber + ' - ' + p.ProjectName as ProjectFullName,
	u.FirstName + ' ' + u.LastName as UserName,
	s.Description as ServiceDescription,
	s.ServiceCode as ServiceCode
  FROM tTime t (nolock)
	LEFT OUTER JOIN tTask ta (nolock) on t.TaskKey = ta.TaskKey
	LEFT OUTER JOIN tProject p (nolock) on t.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tService s (nolock) on t.ServiceKey = s.ServiceKey
	INNER JOIN tUser u (nolock) on t.UserKey = u.UserKey
  WHERE
   TimeKey = @TimeKey
 RETURN 1
GO
