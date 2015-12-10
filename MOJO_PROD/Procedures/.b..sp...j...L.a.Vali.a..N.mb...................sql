USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadValidateNumber]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadValidateNumber]

		@CompanyKey int,
		@UserKey int,
		@ProjectNumber varchar(50),
		@ReturnRow tinyint = 0

AS

/*
|| When      Who Rel     What
|| 4/25/08   CRG 1.0.0.0 Added ability to return whole project row if desired
|| 1/6/10	 GWG 10.5.1.6 Added logic for access any project
*/

declare @ProjectKey int, @SecurityGroupKey int, @CheckAssignment tinyint

select @CheckAssignment = 1

if exists(select 1 from tUser (nolock) where UserKey = @UserKey and Administrator = 1)
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
		select @ProjectKey = ProjectKey 
		from tProject (nolock) 
		where CompanyKey = @CompanyKey
		and UPPER(ProjectNumber) = UPPER(@ProjectNumber)
	else
		select @ProjectKey = p.ProjectKey
		from tProject p (nolock)
		inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey 
		where p.CompanyKey = @CompanyKey 
		and a.UserKey = @UserKey
		and UPPER(ProjectNumber) = UPPER(@ProjectNumber)
	
	IF @ReturnRow = 1
		EXEC sptProjectGetBasic @ProjectKey
	ELSE	
		return ISNULL(@ProjectKey, 0)
GO
