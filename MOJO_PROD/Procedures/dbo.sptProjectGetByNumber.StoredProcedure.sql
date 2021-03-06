USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetByNumber]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetByNumber]

	(
		@CompanyKey int,
		@UserKey int,
		@ProjectNumber varchar(50)
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 1/12/10	 RLB 10.5.1.6 Added logic for access any project
|| 2/2/12    CRG 10.5.5.2 Modified so that the ProjectNumber check is not case sensitive
*/

declare @SecurityGroupKey int, @CheckAssignment tinyint

select @CheckAssignment = 1

if exists(Select 1 from tUser (nolock) Where UserKey = @UserKey and Administrator = 1)
	select @CheckAssignment = 0
	
--If the Import is getting the ProjectKey, it will pass 0 for the @UserKey.	
if @UserKey = 0
	select @CheckAssignment = 0
	
	
if @CheckAssignment = 1
BEGIN
Select @SecurityGroupKey = SecurityGroupKey from tUser (nolock) Where UserKey = @UserKey

	if exists (select 1 from tRight r (nolock)
			inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
			where ra.EntityType = 'Security Group'
			and   ra.EntityKey = @SecurityGroupKey
			and   r.RightID = 'prjAccessAny')
		select @CheckAssignment = 0
END	

	


if @CheckAssignment = 0
	Select * from tProject (nolock) Where CompanyKey = @CompanyKey and UPPER(ProjectNumber) = UPPER(@ProjectNumber)
else
	Select * from tProject (nolock)
		Inner join tAssignment (nolock) on tProject.ProjectKey = tAssignment.ProjectKey 
		Where CompanyKey = @CompanyKey 
		and tAssignment.UserKey = @UserKey
		and UPPER(ProjectNumber) = UPPER(@ProjectNumber)
GO
