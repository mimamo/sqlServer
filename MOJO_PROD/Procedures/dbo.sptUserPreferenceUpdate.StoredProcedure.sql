USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserPreferenceUpdate]
	@UserKey int,
	@TimesheetRequired tinyint,
	@HoursMonday decimal(24,4),
	@HoursTuesday decimal(24,4),
	@HoursWednesday decimal(24,4),
	@HoursThursday decimal(24,4),
	@HoursFriday decimal(24,4),
	@HoursSaturday decimal(24,4),
	@HoursSunday decimal(24,4),
	@RequireMinimumHours tinyint

AS --Encrypt

/*
|| When      Who Rel      What
|| 05/13/13  MFT 10.5.6.8 Added RequireMinimumHours
*/

IF EXISTS(SELECT 1 FROM tUserPreference (nolock) WHERE UserKey = @UserKey)
	UPDATE
		tUserPreference
	SET
		TimesheetRequired = @TimesheetRequired,
		HoursMonday = @HoursMonday,
		HoursTuesday = @HoursTuesday,
		HoursWednesday = @HoursWednesday,
		HoursThursday = @HoursThursday,
		HoursFriday = @HoursFriday,
		HoursSaturday = @HoursSaturday,
		HoursSunday = @HoursSunday,
		RequireMinimumHours = @RequireMinimumHours
	WHERE
		UserKey = @UserKey 

ELSE
	INSERT tUserPreference
		(
		UserKey,
		TimesheetRequired,
		HoursMonday,
		HoursTuesday,
		HoursWednesday,
		HoursThursday,
		HoursFriday,
		HoursSaturday,
		HoursSunday,
		RequireMinimumHours
		)

	VALUES
		(
		@UserKey,
		@TimesheetRequired,
		@HoursMonday,
		@HoursTuesday,
		@HoursWednesday,
		@HoursThursday,
		@HoursFriday,
		@HoursSaturday,
		@HoursSunday,
		@RequireMinimumHours
		)
GO
