USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetCCUserList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetCCUserList]
	(
	@GLAccountKey int
	,@UserKey int 
	)
AS --Encrypt

	SET NOCOUNT ON

/*
|| When      Who Rel     What
|| 10/20/11  GHL 10.549  Created for credit card entry screen (Add mode)
|| 11/01/11  GHL 10.549  (125194) Added security based on user when getting the list of users 
*/

	declare @Administrator int
	declare @SecurityGroupKey int
	declare @AddOtherCreditCardCharges int

	select @Administrator = isnull(Administrator, 0)
		  ,@SecurityGroupKey = isnull(SecurityGroupKey, 0)
	from   tUser (nolock)
	where  UserKey = @UserKey

	if @Administrator = 1
		select @AddOtherCreditCardCharges = 1 
	else
	begin
		if exists (select 1 from tRight r (nolock)
					inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey 
						and ra.EntityKey = @SecurityGroupKey and ra.EntityType ='Security Group'
				   where r.RightID = 'purch_addothercreditcardcharge'
				   )
				   select @AddOtherCreditCardCharges = 1
				else
				   select @AddOtherCreditCardCharges = 0
	end	

	if @AddOtherCreditCardCharges = 1
		-- List of all users for that credit card
		select  glau.*
			   ,isnull(u.FirstName + ' ', '') + u.LastName as FormattedName
		from    tUser u (nolock) 
			inner join tGLAccountUser glau (nolock) on glau.UserKey = u.UserKey 
		where glau.GLAccountKey = @GLAccountKey
		and   u.Active = 1 
		order by isnull(u.FirstName + ' - ', '') + u.LastName

	else
		-- That would be the single user if he has rights to that credit card
		select  glau.*
			   ,isnull(u.FirstName + ' ', '') + u.LastName as FormattedName
		from    tUser u (nolock) 
			inner join tGLAccountUser glau (nolock) on glau.UserKey = u.UserKey 
		where glau.GLAccountKey = @GLAccountKey
		and   glau.UserKey = @UserKey
		and   u.Active = 1 
		order by isnull(u.FirstName + ' - ', '') + u.LastName


	RETURN 1
GO
