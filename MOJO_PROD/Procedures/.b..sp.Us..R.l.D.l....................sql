USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserRoleDelete]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sptUserRoleDelete]
	@UserRoleKey int

AS --Encrypt

--did not find the key in any other tables tc 12/29
--if exists(select 1 from tLead (nolock) where UserRoleKey = @UserRoleKey)
	--return -1

	DELETE
	FROM tUserRole
	WHERE
		UserRoleKey = @UserRoleKey 

	RETURN 1
GO
