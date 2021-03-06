USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetGLCompanyList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetGLCompanyList]
	(
	@GLAccountKey int
	)
	
AS --Encrypt

/*
|| When     Who Rel       What
|| 10/08/12 GHL 10.5.6.1  Created for credit card screens for which the list of GL companies may be restricted
||                        in the lookups
*/

	SET NOCOUNT ON 

	declare @RestrictToGLCompany int

	select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0)
	from   tGLAccount (nolock)
	where  GLAccountKey = @GLAccountKey

	-- nothing to return if we do not restrict to gl companies
	if @RestrictToGLCompany = 0
		select  *
		from    tGLCompanyAccess  (nolock)
		where   1 = 2

	select  *
	from    tGLCompanyAccess  (nolock)
	where   Entity = 'tGLAccount'
	and     EntityKey = @GLAccountKey  

	RETURN 1
GO
