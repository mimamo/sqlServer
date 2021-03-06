USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityUpdateEmailMarketing]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityUpdateEmailMarketing]
	@UserKey INT,
	@CompanyKey INT,
	@ActivityDate DATETIME,
	@Subject VARCHAR(500)
AS

/*
|| When      Who Rel      What
|| 03/08/10  QMD 10.5.2.0 Created to insert activities from the email marketing
|| 01/25/11  QMD 10.5.4.0 Modified date clause to exclude time
*/

DECLARE @ActivityKey INT

	--look for existing activity	
	SELECT	@ActivityKey = ISNULL(MAX(ActivityKey),0)
	FROM	tActivity (NOLOCK)
	WHERE	CompanyKey = @CompanyKey
	AND		Convert(DateTime, Convert(VarChar, ActivityDate, 101)) = Convert(DateTime, Convert(VarChar, @ActivityDate, 101))
	AND		UPPER(LTRIM(RTRIM(Subject))) = UPPER(LTRIM(RTRIM(@Subject)))

	IF @ActivityKey = 0
		BEGIN		
			INSERT tActivity
					(
					CompanyKey,
					ParentActivityKey,
					RootActivityKey,
					Private,
					Type,
					Priority,
					Subject,
					ContactCompanyKey,
					ContactKey,
					UserLeadKey,
					LeadKey,
					ProjectKey,
					TaskKey,
					CMFolderKey,
					StandardActivityKey,
					ActivityTypeKey,
					AssignedUserKey,
					OriginatorUserKey,
					VisibleToClient,
					Outcome,
					ActivityDate,
					StartTime,
					EndTime,
					ReminderMinutes,
					Completed,
					DateCompleted,
					Notes,
					DateAdded,
					DateUpdated,
					AddedByKey,
					UpdatedByKey
					)

				VALUES
					(
					@CompanyKey,
					0,
					0,
					0,
					NULL,
					NULL,
					@Subject,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					1,
					@ActivityDate,
					NULL,
					NULL,
					0,
					0,
					NULL,
					NULL,
					GETUTCDATE(),
					GETUTCDATE(),
					@UserKey,
					@UserKey
					)

				SELECT @ActivityKey = @@IDENTITY

				UPDATE tActivity SET RootActivityKey = @ActivityKey WHERE ActivityKey = @ActivityKey
		END
	
	RETURN @ActivityKey
GO
