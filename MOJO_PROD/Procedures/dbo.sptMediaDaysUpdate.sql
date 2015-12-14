USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaDaysUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaDaysUpdate]
	 @MediaDayKey int
	,@CompanyKey int
	,@Days varchar(50)
	,@Description varchar(1000)
	,@Monday tinyint
	,@Tuesday tinyint
	,@Wednesday tinyint
	,@Thursday tinyint
	,@Friday tinyint
	,@Saturday tinyint
	,@Sunday tinyint
	,@Active tinyint


AS --Encrypt
/*
|| When      Who Rel      What
|| 06/04/13  WDF 10.5.6.9 Created
|| 02/03/14  PLC 10.5.7.6 Added Mon - Fri columns
|| 02/05/14  PLC 10.5.7.6 Added Active column
*/

IF 	@MediaDayKey <= 0
   if exists(Select 1 from tMediaDays (nolock) Where CompanyKey = @CompanyKey and Days = @Days)
	   Return -1

IF 	@MediaDayKey <= 0
	BEGIN
		INSERT tMediaDays
			(
			 CompanyKey
			,Days
			,Description
			,Monday
			,Tuesday
			,Wednesday
			,Thursday
			,Friday
			,Saturday
			,Sunday
			,Active
			)
		VALUES
			(
			 @CompanyKey
			,@Days
			,@Description
			,@Monday
			,@Tuesday
			,@Wednesday
			,@Thursday
			,@Friday
			,@Saturday
			,@Sunday
			,@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaDays
		SET
			Days = @Days
		    ,Description = @Description
			,Monday = @Monday
			,Tuesday = @Tuesday
			,Wednesday = @Wednesday
			,Thursday = @Thursday
			,Friday = @Friday
			,Saturday = @Saturday
			,Sunday = @Sunday
			,Active = @Active
		WHERE
			MediaDayKey = @MediaDayKey 

		RETURN @MediaDayKey
	END
GO
