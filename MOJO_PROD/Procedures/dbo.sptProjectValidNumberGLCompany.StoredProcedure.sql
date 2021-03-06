USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectValidNumberGLCompany]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectValidNumberGLCompany]

	(
		@CompanyKey int,
		@ProjectNumber varchar(50),
		@UserKey int,
		@ActiveOnly tinyint,
		@GLCompanyKey int, -- 0/null is a valid value 
		@AccountingType int = -1  -- -1 do not check rights, 0 check prjAccessAny right, 1 check prjChargeAny right
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 08/03/07 GHL 8.5   Clone of sptProjectValidNumber, but added GLCompanyKey
||                    Returns ProjectKey:
||                    >0 valid project
||                    =0 incorrect ProjectNumber OR User
||                    -1 incorrect GLCompanyKey
|| 10/06/09 GHL 10.5    (63999) Added @AccountingType parameter so that the rights can be checked or not
|| 03/29/12 GHL 10.554  Added ICT logic
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

  
Declare @ProjectKey int, @ProjectGLCompanyKey int

if @CheckAssignment = 1
begin

-- All
if @ActiveOnly = 0


	Select @ProjectKey = p.ProjectKey
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.ProjectKey = a.ProjectKey

-- Active Only	
if @ActiveOnly = 1

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.ProjectKey = a.ProjectKey and
		p.Active = 1
	
-- Not Closed
if @ActiveOnly = 2

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.ProjectKey = a.ProjectKey and
		p.Closed = 0

-- Time Entry
if @ActiveOnly = 3

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock),
		tProjectStatus ps (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.ProjectKey = a.ProjectKey and
		p.ProjectStatusKey = ps.ProjectStatusKey and
		ps.TimeActive = 1 and
		p.Closed = 0

-- Expense Entry
if @ActiveOnly = 4

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock),
		tProjectStatus ps (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.ProjectKey = a.ProjectKey and
		p.ProjectStatusKey = ps.ProjectStatusKey and
		ps.ExpenseActive = 1 and
		p.Closed = 0
		
-- 	Template
if @ActiveOnly = 5

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.Template = 1
end

if @CheckAssignment = 0
begin

-- All
if @ActiveOnly = 0


	Select @ProjectKey = p.ProjectKey
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) 
		
-- Active Only	
if @ActiveOnly = 1

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.Active = 1
	
-- Not Closed
if @ActiveOnly = 2

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.Closed = 0

-- Time Entry
if @ActiveOnly = 3

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock),
		tProjectStatus ps (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.ProjectStatusKey = ps.ProjectStatusKey and
		ps.TimeActive = 1 and
		p.Closed = 0

-- Expense Entry
if @ActiveOnly = 4

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock),
		tProjectStatus ps (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.ProjectStatusKey = ps.ProjectStatusKey and
		ps.ExpenseActive = 1 and
		p.Closed = 0
		
-- 	Template
if @ActiveOnly = 5

	Select @ProjectKey = p.ProjectKey 
			,@ProjectGLCompanyKey = p.GLCompanyKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) and
		p.Template = 1
end



	-- return 0 if wrong project number or user
	if isnull(@ProjectKey, 0) = 0
		return 0
	
	-- now compare GLCompanies
	declare @UseGLCompany int
	declare @RestrictToGLCompany int

	Select @UseGLCompany = isnull(UseGLCompany, 0)
	      ,@RestrictToGLCompany = isnull(RestrictToGLCompany, 0)
	From   tPreference (nolock)
	Where  CompanyKey = @CompanyKey
	
	-- return now if we do not use GLCompanies
	if @UseGLCompany = 0
		return @ProjectKey
			
	select @ProjectGLCompanyKey = isnull(@ProjectGLCompanyKey, 0)
	       ,@GLCompanyKey = isnull(@GLCompanyKey, 0)
			
		
	if @ProjectGLCompanyKey not in
		(
		select  isnull(@GLCompanyKey, 0) 
		union
		Select TargetGLCompanyKey from tGLCompanyMap (nolock) Where SourceGLCompanyKey = @GLCompanyKey
		)
		return -1	
	
	if @RestrictToGLCompany = 1
	begin
		if @ProjectGLCompanyKey not in (
			Select GLCompanyKey from tUserGLCompanyAccess (nolock) Where UserKey = @UserKey
		)
		return -1
	end

	return @ProjectKey
GO
