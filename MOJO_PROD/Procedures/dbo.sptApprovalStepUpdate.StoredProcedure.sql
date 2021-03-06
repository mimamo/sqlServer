USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUpdate]
	@ApprovalStepKey int,
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Subject varchar(100),
	@Action smallint,
	@Instructions varchar(1000),
	@EnableRouting tinyint,
	@AllApprove tinyint,
	@DaysToApprove int = 0,
	@Internal tinyint = NULL,
	@Pause tinyint = 0,
	@LoginRequired tinyint = 0,
	@SendReminder tinyint = 0,
	@DueDate datetime = NULL,
	@ReminderType tinyint = 0,
	@ReminderInterval int = NULL,
	@TimeZoneIndex int = NULL

AS --Encrypt

	/*
	|| When     Who		Rel			What
	|| 08/01/11 MAS		10.5.x.x	Added @Internal
	|| 11/01/11 QMD		10.5.4.9	Added @Pause
	|| 03/29/12 QMD		10.5.5.5	Added @DueDate
	|| 10/05/12 QMD		10.5.6.0	Added @ReminderType, @ReminderInterval
	|| 04/25/13 QMD		10.5.6.7	Added @TimeZoneIndex
	|| 11/21/14 QMD		10.5.8.6	(236970) Added Status Name update
	*/

	UPDATE
		tApprovalStep
	SET
		CompanyKey = @CompanyKey,
		Entity = @Entity,
		EntityKey = @EntityKey,
		Subject = @Subject,
		Action = @Action,
		Instructions = @Instructions,
		EnableRouting = @EnableRouting,
		AllApprove = @AllApprove,
		DaysToApprove = @DaysToApprove,
		Internal = @Internal,
		Pause = @Pause,
		LoginRequired = @LoginRequired,
		SendReminder = @SendReminder,
		DueDate = @DueDate,
		ReminderType = @ReminderType,
		ReminderInterval = @ReminderInterval,
		TimeZoneIndex = @TimeZoneIndex
	WHERE
		ApprovalStepKey = @ApprovalStepKey 
	
	--Status name update 
	exec sptApprovalStepUpdateStatusNames @ApprovalStepKey

	RETURN 1
GO
