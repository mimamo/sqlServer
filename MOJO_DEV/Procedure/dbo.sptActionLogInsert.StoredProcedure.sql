USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptActionLogInsert]    Script Date: 04/29/2016 16:40:56 ******/
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
	@UserKey int = NULL,
	@CampaignKey int = NULL
AS --Encrypt

/*
|| When     Who	Rel			What
|| 12/06/12 MAS 10.5.6.3	Added Optional @UserKey and UserName lookup if @ActionBy is NULL
|| 12/19/12 RLB 10.5.6.3    Made Action column bigger
|| 10/13/15 RLB 10.5.9.8    Added CampaignKey for Plat
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
		UserKey,
		CampaignKey
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
		@UserKey,
		@CampaignKey
		)
	
Return 1

GO


