USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepInsert]
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@Subject varchar(100),
	@Action smallint,
	@Instructions varchar(1000),
	@EnableRouting tinyint,
	@AllApprove tinyint,
	@DaysToApprove int,
	@Internal tinyint = NULL,
	@Pause tinyint = 0,
	@LoginRequired tinyint = 0,
	@SendReminder tinyint = 0,
	@DueDate datetime = NULL,
	@ReminderType tinyint = 0,
	@ReminderInterval int = NULL,
	@TimeZoneIndex int = NULL,
	@oIdentity INT OUTPUT
AS --Encrypt

	/*
	|| When     Who		Rel			What
	|| 08/01/11 MAS		10.5.x.x	Added @Internal
	|| 03/29/12 QMD		10.5.5.5	Added @DueDate
	|| 10/05/12 QMD		10.5.6.0	Added @ReminderType, @ReminderInterval
	|| 04/25/13 QMD		10.5.6.7	Added @TimeZoneIndex
	*/

Declare @DisplayOrder int

	Select @DisplayOrder = ISNULL(Max(DisplayOrder), 0) + 1 from tApprovalStep (nolock) Where Entity = @Entity and EntityKey = @EntityKey

	INSERT tApprovalStep
		(
		CompanyKey,
		Entity,
		EntityKey,
		Subject,
		DisplayOrder,
		Action,
		Instructions,
		EnableRouting,
		AllApprove,
		DaysToApprove,
		Internal,
		Pause,
		LoginRequired,
		SendReminder,
		DueDate,
		ReminderType,
		ReminderInterval,
		TimeZoneIndex
		)

	VALUES
		(
		@CompanyKey,
		@Entity,
		@EntityKey,
		@Subject,
		@DisplayOrder,
		@Action,
		@Instructions,
		@EnableRouting,
		@AllApprove,
		@DaysToApprove,
		@Internal,
		@Pause,
		@LoginRequired,
		@SendReminder,
		@DueDate,
		@ReminderType,
		@ReminderInterval,
		@TimeZoneIndex
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
