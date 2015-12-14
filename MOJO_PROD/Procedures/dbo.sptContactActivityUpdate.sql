USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactActivityUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactActivityUpdate]
	@ActivityKey int,
	@CompanyKey int,
	@Type varchar(50),
	@Priority varchar(20),
	@Subject varchar(200),
	@ContactCompanyKey int,
	@ContactKey int,
	@AssignedUserKey int,
	@Status smallint,
	@Outcome smallint,
	@ActivityDate smalldatetime,
	@ActivityTime varchar(50),
	@LeadKey int,
	@ProjectKey int,
	@Notes text

AS --Encrypt

  /*
  || When     Who Rel    What
  || 01/08/09 GHL 10.016 Updating now tActivity instead of tContactActivity
  */

Declare @DateCompleted smalldatetime
Declare @Completed int

if @Status = 2
	Select @DateCompleted = GETDATE(), @Completed = 1
else
	Select @DateCompleted = NULL, @Completed = 0
	
	UPDATE
		tActivity
	SET
		CompanyKey = @CompanyKey,
		Type = @Type,
		Priority = @Priority,
		Subject = @Subject,
		ContactCompanyKey = @ContactCompanyKey,
		ContactKey = @ContactKey,
		AssignedUserKey = @AssignedUserKey,
		Completed = @Completed,
		Outcome = @Outcome,
		ActivityDate = @ActivityDate,
		ActivityTime = @ActivityTime,
		DateCompleted = @DateCompleted,
		LeadKey = @LeadKey,
		ProjectKey = @ProjectKey,
		Notes = @Notes,
		DateUpdated = GETDATE()
	WHERE
		ActivityKey = @ActivityKey 

	RETURN 1
GO
