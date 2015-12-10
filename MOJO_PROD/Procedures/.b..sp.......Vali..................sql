USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSourceValid]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sptSourceValid]
	 @CompanyKey int
	,@SourceName varchar(200)

as --Encrypt

declare  @SourceKey int

	select @SourceKey = SourceKey
	from tSource (nolock)
	where CompanyKey = @CompanyKey
	and upper(SourceName) = upper(@SourceName)
	and	Active = 1
		
return isnull(@SourceKey, 0)
GO
