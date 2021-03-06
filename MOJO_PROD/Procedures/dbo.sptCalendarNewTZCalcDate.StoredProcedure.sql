USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarNewTZCalcDate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarNewTZCalcDate]
	@DateIn datetime,
	@OldStdOffset int,
	@OldDaylightOffset int,
	@NewStdOffset int,
	@NewDaylightOffset int,
	@OldDaylightStart datetime,
	@OldDaylightEnd datetime,
	@NewDaylightStart datetime,
	@NewDaylightEnd datetime,
	@DateOut datetime OUTPUT

AS --Encrypt

/*
This SP is used essentially as a function so that the logic doesn't have to be repeated
in sptCalendarChangeTimeZone.

NOTE-- All Offset values are in MINUTES.
*/

	DECLARE	@MoveOffset int,
			@LocalDateIn datetime
			
	SELECT	@LocalDateIn = DATEADD(mi, @OldStdOffset, @DateIn)
	
	IF @LocalDateIn BETWEEN @OldDaylightStart AND @OldDaylightEnd
		BEGIN
			--Date was in Daylight
			IF @LocalDateIn BETWEEN @NewDaylightStart AND @NewDaylightEnd
				BEGIN	
					--Date is still in Daylight
					SELECT	@MoveOffset =  @OldDaylightOffset - @NewDaylightOffset
				END
			ELSE
				BEGIN
					--Date will not be in Daylight anymore
					SELECT	@MoveOffset = @OldDaylightOffset - @NewStdOffset
				END
		END
	ELSE
		BEGIN
			--Date was not in Daylight
			IF @LocalDateIn BETWEEN @NewDaylightStart AND @NewDaylightEnd
				BEGIN	
					--Date will now be in Daylight
					SELECT	@MoveOffset = @OldStdOffset - @NewDaylightOffset
				END
			ELSE
				BEGIN
					--Date will still not be in Daylight
					SELECT	@MoveOffset = @OldStdOffset - @NewStdOffset
				END
		END
	
	SELECT	@DateOut = DATEADD(mi, @MoveOffset, @DateIn)
GO
