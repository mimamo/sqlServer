USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectValidNumber]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectValidNumber]

	(
		@CompanyKey int,
		@ProjectNumber varchar(50),
		@UserKey int,
		@ActiveOnly tinyint,
		@AccountingType int = -1,  -- -1 do not check rights, 0 check prjAccessAny right, 1 check prjChargeAny right
		@ValidateProjectKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel      What
|| 03/08/07 RTC 8.4.0.6  made project number comparison case insensitive
|| 05/17/07 GHL 8.4.2.2  Trimmed project number. Bug 9247.
|| 12/13/07 CRG 8.5      Removed Closed restriction on Expense type so that it matches Flex validation.
|| 10/06/09 GHL 10.5     (63999) Added @AccountingType parameter so that the rights can be checked or not
|| 07/02/12 RLB 10.5.5.7 (146899) Added validateprojectkey for validation on project load
|| 11/05/14  RLB 10.5.8.6 Added changes for Abelson Taylor Enhancement AnyoneChargeTime
*/
  
Declare @Administrator int
Declare @SecurityGroupKey int  
Declare @CheckAssignment int  
Declare @ProjectKey int
Declare @AnyoneChargeTime tinyint
Declare @AnyoneChargeTimeProjectKey int

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

-- Abelson Taylor Enhancement AnyoneChargeTime need to see if there is a project if so then check AnyoneChargeTime to set checkassigned option
Select @AnyoneChargeTimeProjectKey = ISNULL(p.ProjectKey, 0) 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey)

IF @AnyoneChargeTimeProjectKey > 0
begin
	select @AnyoneChargeTime = AnyoneChargeTime from tProject (nolock) where ProjectKey = @AnyoneChargeTimeProjectKey

	if @CheckAssignment = 1 and @AnyoneChargeTime = 1
		select @CheckAssignment = 0
end

if @CheckAssignment = 1
begin
-- All
if @ActiveOnly = 0	
	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.ProjectKey = a.ProjectKey
			
-- Active Only	
if @ActiveOnly = 1

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.ProjectKey = a.ProjectKey and
		p.Active = 1
	
-- Not Closed
if @ActiveOnly = 2

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.ProjectKey = a.ProjectKey and
		p.Closed = 0

-- Time Entry
if @ActiveOnly = 3

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock),
		tProjectStatus ps (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.ProjectKey = a.ProjectKey and
		p.ProjectStatusKey = ps.ProjectStatusKey and
		ps.TimeActive = 1 and
		p.Closed = 0

-- Expense Entry
if @ActiveOnly = 4

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock),
		tAssignment a (nolock),
		tProjectStatus ps (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		a.UserKey = @UserKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.ProjectKey = a.ProjectKey and
		p.ProjectStatusKey = ps.ProjectStatusKey and
		ps.ExpenseActive = 1 
		
-- 	Template
if @ActiveOnly = 5

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.Template = 1

end



if @CheckAssignment = 0
begin
-- All
if @ActiveOnly = 0	
	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey)
			
-- Active Only	
if @ActiveOnly = 1

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.Active = 1
	
-- Not Closed
if @ActiveOnly = 2

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.Closed = 0

-- Time Entry
if @ActiveOnly = 3

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock),
		tProjectStatus ps (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.ProjectStatusKey = ps.ProjectStatusKey and
		ps.TimeActive = 1 and
		p.Closed = 0

-- Expense Entry
if @ActiveOnly = 4

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock),
		tProjectStatus ps (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.ProjectStatusKey = ps.ProjectStatusKey and
		ps.ExpenseActive = 1 
		
-- 	Template
if @ActiveOnly = 5

	Select @ProjectKey = p.ProjectKey 
	From 
		tProject p (nolock)
	Where
		p.CompanyKey = @CompanyKey and
		(upper(p.ProjectNumber) = ltrim(rtrim(upper(@ProjectNumber))) or p.ProjectKey = @ValidateProjectKey) and
		p.Template = 1

end
	
	return isnull(@ProjectKey, 0)
GO
