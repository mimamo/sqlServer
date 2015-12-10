USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaBroadcastLengthUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaBroadcastLengthUpdate]
	@MediaBroadcastLengthKey int,
	@CompanyKey int,
	@POKind smallint,
	@BroadcastLengthID varchar(50),
	@BroadcastLength int,
	@Description varchar(MAX),
	@Active tinyint
	

AS --Encrypt
/*
|| When      Who Rel      What
|| 07/17/13  MAS 10.5.6.9 Created
*/

if exists(Select 1 from tMediaBroadcastLength (nolock) 
		  Where CompanyKey = @CompanyKey 
		  and BroadcastLengthID = @BroadcastLengthID
		  and MediaBroadcastLengthKey <> @MediaBroadcastLengthKey)
	Return -1

IF 	@MediaBroadcastLengthKey <= 0
	BEGIN
		INSERT tMediaBroadcastLength
			(
			CompanyKey,
			POKind,
			BroadcastLengthID,
			BroadcastLength,
			Description,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@POKind,
			@BroadcastLengthID,
			@BroadcastLength,
			@Description,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaBroadcastLength
		SET
			BroadcastLengthID = @BroadcastLengthID,
			BroadcastLength = @BroadcastLength,
			Description = @Description,
			Active = @Active
		WHERE
			MediaBroadcastLengthKey = @MediaBroadcastLengthKey 

		RETURN @MediaBroadcastLengthKey
	END
GO
