USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeCopy]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeCopy]
	@CopyTimeKey uniqueidentifier,
	@TimeSheetKey int,
	@NewTimeKey uniqueidentifier OUTPUT
AS

/*
|| When      Who Rel      What
|| 5/23/11   CRG 10.5.4.4 Created to allow copy of time entries on drag/drop
|| 6/14/11   CRG 10.5.4.5 Now copying Comments as well
*/

	DECLARE	@UserKey int,
			@ProjectKey int,
			@TaskKey int,
			@ServiceKey int,
			@ActualHours decimal(24,4),
			@RateLevel int,
			@Comments varchar(2000)

	SELECT	@UserKey = UserKey,
			@ProjectKey = ProjectKey,
			@TaskKey = TaskKey,
			@ServiceKey = ServiceKey,
			@ActualHours = ActualHours,
			@RateLevel = RateLevel,
			@Comments = Comments
	FROM	tTime (nolock)
	WHERE	TimeKey = @CopyTimeKey

	DECLARE @RetVal int

	EXEC @RetVal = sptTimeInsert
			@TimeSheetKey,
			@UserKey,
			@ProjectKey,
			@TaskKey,
			@ServiceKey,
			NULL, --WorkDate
			NULL, --StartTime,
			NULL, --EndTime,
			@ActualHours,
			0,
			@Comments,
			@RateLevel,
			NULL,
			0,
			@NewTimeKey output
GO
