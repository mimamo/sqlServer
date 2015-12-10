USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestUpdate]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestUpdate]
	@RequestKey int,
	@UserKey int,
	@CompanyKey int,
	@ClientKey int,
	@RequestedBy varchar(150),
	@NotifyEmail varchar(100),
	@DateCompleted smalldatetime,
	@Subject varchar(100),
	@ClientProjectNumber varchar(200),
	@ProjectDescription text,
	@DueDate smalldatetime,
	@CampaignID varchar(50)

AS --Encrypt

 /*
  || When     Who Rel       What
  || 11/10/10 RLB 10.5.3.8  (91299) Fields added for enhancement
  || 05/29/12 QMD 10.5.5.6  (143615) Added CampaignID
  || 03/25/15 WDF 10.5.9.0  (250961) Added @UserKey, UpdatedByKey and DateUpdated
 */

	UPDATE
		tRequest
	SET
		CompanyKey = @CompanyKey,
		ClientKey = @ClientKey,
		RequestedBy = @RequestedBy,
		NotifyEmail = @NotifyEmail,
		DateCompleted = @DateCompleted,
		Subject = @Subject,
		ClientProjectNumber = @ClientProjectNumber,
		ProjectDescription = @ProjectDescription,
		DueDate = @DueDate,
		CampaignID = @CampaignID,
		UpdatedByKey = @UserKey,
		DateUpdated = GETUTCDATE()
	WHERE
		RequestKey = @RequestKey 

	RETURN 1
GO
