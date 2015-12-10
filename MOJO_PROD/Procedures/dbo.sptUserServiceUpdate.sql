USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserServiceUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserServiceUpdate]

	(
		@UserKey int,
		@ServiceKey int,
		@Selected tinyint
	)

AS --Encrypt


if @Selected = 1
BEGIN  
  
	if exists(select 1 from tUserService (nolock) where UserKey = @UserKey and ServiceKey = @ServiceKey)
		return 1
		
	Insert tUserService
		(
		UserKey,
		ServiceKey
		)
	Values
		(
		@UserKey,
		@ServiceKey
		)

END
ELSE
BEGIN

	Delete tUserService Where UserKey = @UserKey and ServiceKey = @ServiceKey


END
GO
