USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRestrictValid]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRestrictValid]
	(
	@CompanyKey int
	,@ItemID varchar(50)   -- can also be ItemName
	,@ItemType smallint    -- -1 All, 0 Purchase, 1 Print, 2 Broadcast , 3 Expense Report
	,@SearchMode varchar(20) -- blank, reports, transactions
	,@GLCompanyKey int       -- 0 All, >0 specific GL company
	,@UserKey int 
	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/09/12  RLB 10.561   Created to validate item for a certain GL Company 
*/
	select @ItemID = upper(ltrim(rtrim(@ItemID)))
	select @SearchMode = isnull(@SearchMode, '')
	select @GLCompanyKey = isnull(@GLCompanyKey, 0)

	Declare @ItemKey int

	if @SearchMode = ''	
		SELECT @ItemKey = ItemKey
		FROM tItem (nolock)
		WHERE
			CompanyKey = @CompanyKey 
			and (upper(ItemID) = @ItemID or upper(ItemName) = @ItemID)
			and (@ItemType = -1 or ItemType = @ItemType) 

	if @SearchMode = 'reports'
		SELECT @ItemKey = i.ItemKey
		FROM tItem i (nolock)
			inner join tGLCompanyAccess glca (nolock) on i.ItemKey = glca.EntityKey and glca.Entity = 'tItem'
			inner join tUserGLCompanyAccess uglca (nolock) on glca.GLCompanyKey = uglca.GLCompanyKey 
		where i.CompanyKey = @CompanyKey 
		and   (upper(ItemID) = @ItemID or upper(ItemName) = @ItemID) 
		and   (@ItemType = -1 or ItemType = @ItemType) 
		and   uglca.UserKey = @UserKey
		and   (@GLCompanyKey <=0
				or
			    glca.GLCompanyKey =  @GLCompanyKey
			  )

	-- for this mode, GLCompanyKey is required and we do not check the user's rights
	if @SearchMode = 'transactions'
		SELECT @ItemKey = i.ItemKey 
		FROM tItem i (nolock)
			inner join tGLCompanyAccess glca (nolock) on i.ItemKey = glca.EntityKey and glca.Entity = 'tItem'
		where i.CompanyKey = @CompanyKey 
		and   (upper(ItemID) = @ItemID or upper(ItemName) = @ItemID)
		and   (@ItemType = -1 or ItemType = @ItemType)  
		and   glca.GLCompanyKey =  @GLCompanyKey

	select * from tItem (nolock) where ItemKey = @ItemKey

	RETURN 1
GO
