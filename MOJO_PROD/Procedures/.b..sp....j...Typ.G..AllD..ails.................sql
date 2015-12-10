USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeGetAllDetails]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeGetAllDetails]
	@CompanyKey int

AS --Encrypt

/*
  || When		  Who Rel			  What
  || 09/29/09	MAS 10.5.0.9	Created
  || 11/02/12 MFT 10.5.6.2  Added selected users
*/

	SELECT *
	FROM tProjectType (NOLOCK) 
	WHERE CompanyKey = @CompanyKey
		
-- services
	Select p.ProjectTypeKey, 
	       s.*,
		   ISNULL(s.ServiceCode, '') + ' - ' + ISNULL(s.Description, '') as FullDescription  
	From tProjectType p (nolock)
	Inner join tProjectTypeService pts (nolock) on p.ProjectTypeKey = pts.ProjectTypeKey
	Inner Join tService s (nolock) on  s.ServiceKey = pts.ServiceKey
	Where p.CompanyKey = @CompanyKey
	Order By s.Description

-- masterTasks
	Select p.ProjectTypeKey, 
		   ptmt.DisplayOrder, 
		   mt.*,
		   ISNULL(mt.TaskID, '') + ' - ' + ISNULL(mt.TaskName, '') as FullName 
	From tProjectType p (nolock)
	Inner join tProjectTypeMasterTask ptmt (nolock) on p.ProjectTypeKey = ptmt.ProjectTypeKey
	Inner Join tMasterTask mt (nolock) on ptmt.MasterTaskKey = mt.MasterTaskKey	
	Where p.CompanyKey = @CompanyKey
	Order By ptmt.DisplayOrder

-- selected Users
	SELECT
		pt.ProjectTypeKey,
		u.UserKey,
		ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName
	FROM
		tProjectTypeUser ptu (nolock)
		INNER JOIN tProjectType pt (nolock) ON ptu.ProjectTypeKey = pt.ProjectTypeKey
		INNER JOIN tUser u (nolock) ON ptu.UserKey = u.UserKey
	WHERE
		pt.CompanyKey = @CompanyKey
GO
