USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserValid]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sptUserValid]
	 @CompanyKey int
	,@UserID varchar(100)

as --Encrypt

declare  @UserKey int

	select @UserKey = UserKey
	from tUser (nolock)
	where CompanyKey = @CompanyKey
	and upper(UserID) = upper(@UserID)
		
return isnull(@UserKey, 0)
GO
