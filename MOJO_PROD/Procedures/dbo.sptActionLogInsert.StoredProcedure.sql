USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActionLogInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActionLogInsert]
	@Entity varchar(50),
	@EntityKey int,
	@CompanyKey int,
	@ProjectKey int,
	@Action varchar(200),
	@ActionDate smalldatetime,
	@ActionBy varchar(500),
	@Comments varchar(4000),
	@Reference varchar(200),
	@SourceCompanyID varchar(100),
	@UserKey int = NULL
AS --Encrypt

/*
|| When     Who	Rel			What
|| 12/06/12 MAS 10.5.6.3	Added Optional @UserKey and UserName lookup if @ActionBy is NULL
|| 12/19/12 RLB 10.5.6.3    Made Action column bigger
*/

If @ActionBy IS NULL AND ISNULL(@UserKey,0) > 0
	Select @ActionBy = UserName from vUserName Where UserKey = @UserKey

If ISNULL(@CompanyKey,0) = 0 AND ISNULL(@UserKey,0) > 0
	Select @CompanyKey = CompanyKey from tUser Where UserKey = @UserKey

	INSERT tActionLog
		(
		Entity,
		EntityKey,
		CompanyKey,
		ProjectKey,
		Action,
		ActionDate,
		ActionBy,
		Comments,
		Reference,
		SourceCompanyID,
		UserKey
		)

	VALUES
		(
		@Entity,
		@EntityKey,
		@CompanyKey,
		@ProjectKey,
		@Action,
		@ActionDate,
		@ActionBy,
		@Comments,
		@Reference,
		@SourceCompanyID,
		@UserKey
		)
	
Return 1
GO
