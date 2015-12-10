USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectValidNumberClient]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectValidNumberClient]

	(
		@CompanyKey int,
		@ProjectNumber varchar(50),
		@UserKey int,
		@ClientKey int,
		@GLCompanyKey int = 0,
		@ValidateGLCompany int = 0,
		@AccountingType int = -1  -- -1 do not check rights, 0 check prjAccessAny right, 1 check prjChargeAny right
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 08/03/07 GHL 8.5   Added GLCompanyKey logic
||                    Returns ProjectKey:
||                    >0 valid project
||                    =0 incorrect ProjectNumber OR User OR Client
||                    -1 incorrect GLCompanyKey
*/


 
Declare @Administrator int
Declare @SecurityGroupKey int  
Declare @CheckAssignment int  

select @Administrator = isnull(Administrator, 0), @SecurityGroupKey = isnull(SecurityGroupKey, 0)
from tUser (nolock) where UserKey = @UserKey

select @CheckAssignment = 1

if @Administrator = 1
begin
	select @CheckAssignment = 0
end
else
begin
	-- CMP code, continue checking for assignments
	if @AccountingType = -1
	begin
		select @CheckAssignment = 1
	end
	
	-- WMJ code, check rights
	else if @AccountingType = 0
	begin
		if exists (select 1 from tRight r (nolock)
			inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
			where ra.EntityType = 'Security Group'
			and   ra.EntityKey = @SecurityGroupKey
			and   r.RightID = 'prjAccessAny')
			
			select @CheckAssignment = 0
		else
			select @CheckAssignment = 1
	end

	-- WMJ code, check rights
	else if @AccountingType = 1
	begin
		if exists (select 1 from tRight r (nolock)
			inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
			where ra.EntityType = 'Security Group'
			and   ra.EntityKey = @SecurityGroupKey
			and   r.RightID = 'prjChargeAny')
			
			select @CheckAssignment = 0
		else
			select @CheckAssignment = 1
	end

end

Declare @ProjectKey int, @ParentKey int, @ProjectGLCompanyKey int

Select @ParentKey = ISNULL(ParentCompanyKey, 0) from tCompany (nolock) Where CompanyKey = @ClientKey

if @CheckAssignment = 1
begin
if @ParentKey = 0
BEGIN
	Select @ProjectKey = p.ProjectKey 
	      ,@ProjectGLCompanyKey = p.GLCompanyKey
	From 
		tProject p (nolock)
		inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		p.ProjectNumber = @ProjectNumber and
		p.Closed = 0 and
		p.ClientKey in (Select CompanyKey from tCompany 
			Where CompanyKey = @ClientKey or ParentCompanyKey = @ClientKey)
END
ELSE
BEGIN
	Select @ProjectKey = p.ProjectKey 
	      ,@ProjectGLCompanyKey = p.GLCompanyKey
	From 
		tProject p (nolock)
		inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		p.ProjectNumber = @ProjectNumber and
		p.Closed = 0 and
		p.ClientKey in (Select CompanyKey from tCompany 
			Where CompanyKey = @ParentKey or ParentCompanyKey = @ParentKey)
END
end

if @CheckAssignment = 0
begin
if @ParentKey = 0
BEGIN
	Select @ProjectKey = p.ProjectKey 
	      ,@ProjectGLCompanyKey = p.GLCompanyKey
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		p.ProjectNumber = @ProjectNumber and
		p.Closed = 0 and
		p.ClientKey in (Select CompanyKey from tCompany 
			Where CompanyKey = @ClientKey or ParentCompanyKey = @ClientKey)
END
ELSE
BEGIN
	Select @ProjectKey = p.ProjectKey 
	      ,@ProjectGLCompanyKey = p.GLCompanyKey
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		p.ProjectNumber = @ProjectNumber and
		p.Closed = 0 and
		p.ClientKey in (Select CompanyKey from tCompany 
			Where CompanyKey = @ParentKey or ParentCompanyKey = @ParentKey)
END
end

	-- return now if we have wrong project number OR wrong user OR wrong client
	if isnull(@ProjectKey, 0) = 0
		return 0
	
	-- now compare GLCompanies
	declare @UseGLCompany int
	
	Select @UseGLCompany = isnull(UseGLCompany, 0)
	From   tPreference (nolock)
	Where  CompanyKey = @CompanyKey
	
	-- return now if we do not use GLCompanies
	if @UseGLCompany = 0 Or @ValidateGLCompany = 0
		return @ProjectKey
			
	select @ProjectGLCompanyKey = isnull(@ProjectGLCompanyKey, 0)
	       ,@GLCompanyKey = isnull(@GLCompanyKey, 0)
			
	if @GLCompanyKey <> @ProjectGLCompanyKey 
			return -1	
		
	return @ProjectKey
GO
