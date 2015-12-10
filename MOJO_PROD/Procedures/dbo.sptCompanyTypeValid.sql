USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyTypeValid]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sptCompanyTypeValid]
	 @CompanyKey int
	,@CompanyTypeName varchar(50)

as --Encrypt

declare  @CompanyTypeKey int

	select @CompanyTypeKey = CompanyTypeKey
	from tCompanyType (nolock)
	where CompanyKey = @CompanyKey
	and upper(CompanyTypeName) = upper(@CompanyTypeName)
		
return isnull(@CompanyTypeKey, 0)
GO
