USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeValid]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sptProjectTypeValid]
	 @CompanyKey int
	,@ProjectTypeName varchar(100)

as --Encrypt

declare  @ProjectTypeKey int

	select @ProjectTypeKey = ProjectTypeKey
	from tProjectType (nolock)
	where CompanyKey = @CompanyKey
	and upper(ProjectTypeName) = upper(@ProjectTypeName)
		
return isnull(@ProjectTypeKey, 0)
GO
