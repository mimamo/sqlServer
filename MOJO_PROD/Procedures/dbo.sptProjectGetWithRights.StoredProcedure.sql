USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetWithRights]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[sptProjectGetWithRights]
 (
  @ProjectKey int,
  @UserKey int,
  @Administrator tinyint
 )
AS --Encrypt

  /*
  || When     Who Rel		What
  || 12/10/09 GWG 10.5.1.4  Added in check for Access any project right
  */
  
declare @SecurityGroupKey int

Select @SecurityGroupKey = SecurityGroupKey from tUser Where UserKey = @UserKey

-- check the access any project right
if exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90918 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey)
	Select @Administrator = 1

If @Administrator = 1
	SELECT 
		ProjectKey, 
		ProjectName, 
		ProjectNumber,
		CompanyKey
	FROM tProject (nolock)
	Where ProjectKey = @ProjectKey
else
	SELECT 
		p.ProjectKey, 
		ProjectName, 
		ProjectNumber,
		CompanyKey
	FROM tProject p (nolock)
	inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	Where a.ProjectKey = @ProjectKey and a.UserKey = @UserKey
	
return 1
GO
