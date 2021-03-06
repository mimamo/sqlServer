USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10559]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10559]
AS

/*
|| When      Who Rel      What
|| 8/20/12   CRG 10.5.5.9 Added Opportunity Labor conversion
*/

-- convert VisibleGLCompanyKey to RestrictToGLCompany	

/*
Commented out because this routine blows when adding to a new database
declare @GLAccountKey int, @VisibleGLCompanyKey int, @RestrictToGLCompany int
select @GLAccountKey = -1
while (1=1)
begin
	select @GLAccountKey = min(GLAccountKey)
	from   tGLAccount (nolock)
	where  GLAccountKey > @GLAccountKey
	and    VisibleGLCompanyKey > 0

	if @GLAccountKey is null
		break

	select @VisibleGLCompanyKey = gla.VisibleGLCompanyKey
	      ,@RestrictToGLCompany = pref.RestrictToGLCompany
	from   tGLAccount gla (nolock)
		inner join tPreference pref (nolock) on gla.CompanyKey = pref.CompanyKey
	where  gla.GLAccountKey = @GLAccountKey
	
	if isnull(@RestrictToGLCompany, 0) > 0
	begin
		update tGLAccount
		set    RestrictToGLCompany = 1
		where  GLAccountKey = @GLAccountKey
	
		exec sptGLCompanyAccessInsert 'tGLAccount', @GLAccountKey, @VisibleGLCompanyKey
	end

end
*/

UPDATE	tLead
SET		Labor = ISNULL(SaleAmount, 0) - ISNULL(MediaGross, 0) - ISNULL(OutsideCostsGross, 0)
GO
