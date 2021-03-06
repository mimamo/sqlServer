USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaDemographicUpdate]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaDemographicUpdate]
	@MediaDemographicKey int,
	@CompanyKey int,
	@DemographicID varchar(50),
	@DemographicName varchar(500),
	@POKind int,
	@Active tinyint

AS --Encrypt
/*
|| When      Who Rel      What
|| 06/03/13  MAS 10.5.6.9 Created
|| 07/10/13  GWG 10.5.7.0 Took out audience and rating fields
*/

if exists(Select 1 from tMediaDemographic (nolock) Where CompanyKey = @CompanyKey and DemographicID = @DemographicID and DemographicName <> @DemographicName)
	Return -1

IF 	@MediaDemographicKey <= 0
	BEGIN
		INSERT tMediaDemographic
			(
			CompanyKey,
			DemographicID,
			DemographicName,
			Active,
			POKind
			)

		VALUES
			(
			@CompanyKey,
			@DemographicID,
			@DemographicName,
			@Active,
			@POKind
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaDemographic
		SET
			DemographicID = @DemographicID,
			DemographicName = @DemographicName,
			Active = @Active
		WHERE
			MediaDemographicKey = @MediaDemographicKey 

		RETURN @MediaDemographicKey
	END
GO
