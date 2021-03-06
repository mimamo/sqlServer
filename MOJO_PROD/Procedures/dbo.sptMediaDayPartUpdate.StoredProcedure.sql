USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaDayPartUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaDayPartUpdate]
	@MediaDayPartKey int,
	@CompanyKey int,
	@POKind smallint,
	@DayPartID varchar(50),
	@TimeRange varchar(50),
	@Description varchar(MAX),
	@Prime tinyint,
	@Active tinyint,
	@MediaDayKey int
	

AS --Encrypt
/*
|| When      Who Rel      What
|| 07/17/13  MAS 10.5.6.9 Created
|| 02/03/14  PLC 10.5.7.6 Added MediaDayKey and removed Days of week
|| 02/17/14  PLC 10.5.7.7 Added @BroadcastType 
|| 03/04/14  PLC 10.5.7.7 Removed @BroadcastType 
*/

if exists(Select 1 from tMediaDayPart (nolock) 
          Where CompanyKey = @CompanyKey 
          and DayPartID = @DayPartID
          and MediaDayPartKey <> @MediaDayPartKey)
	Return -1

IF 	@MediaDayPartKey <= 0
	BEGIN
		INSERT tMediaDayPart
			(
			CompanyKey,
			POKind,
			DayPartID,
			TimeRange,
			Description,
			Prime,
			MediaDayKey,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@POKind,
			@DayPartID,
			@TimeRange,
			@Description,
			@Prime,
			@MediaDayKey,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaDayPart
		SET
			DayPartID = @DayPartID,
			TimeRange = @TimeRange,
			Description = @Description,
			Prime = @Prime,
			MediaDayKey = @MediaDayKey,
			Active = @Active
		WHERE
			MediaDayPartKey = @MediaDayPartKey 

		RETURN @MediaDayPartKey
	END
GO
