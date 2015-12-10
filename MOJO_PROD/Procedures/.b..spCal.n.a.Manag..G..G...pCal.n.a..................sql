USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetGroupCalendar]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetGroupCalendar]
	@DistributionGroupKey int
AS

/*
|| When      Who Rel      What
|| 3/9/09    CRG 10.5.0.0 Created to get the calendar for all members in a group for the schedule grid.
|| 6/30/09   CRG 10.5.0.0 Added new parameters to spCalendarManagerGetAvailableCalendars
*/

	/* Assume created in VB
	CREATE TABLE #tAvailableCalendars
		(Section varchar(50) NULL,
		UserName varchar(200) NULL,
		CMFolderKey int NULL,
		FolderName varchar(200) NULL,
		UserKey int NULL,
		Color varchar(50) NULL,
		CanAdd tinyint NULL)
	*/

	DECLARE	@UserKey int
	SELECT	@UserKey = -1
	
	WHILE (1=1)
	BEGIN
		SELECT	@UserKey = MIN(UserKey)
		FROM	tDistributionGroupUser
		WHERE	DistributionGroupKey = @DistributionGroupKey
		AND		UserKey > @UserKey
		
		IF @UserKey IS NULL
			BREAK
		
		EXEC spCalendarManagerGetAvailableCalendars @UserKey, 0, 1, 1, 0
	END

	SELECT DISTINCT Section, CMFolderKey, FolderName
	FROM	#tAvailableCalendars
GO
