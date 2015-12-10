USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMediaAffiliateUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMediaAffiliateUpdate]
	@MediaAffiliateKey int,
	@CompanyKey int,
	@AffiliateID varchar(50),
	@AffiliateName varchar(200),
	@Active tinyint

AS --Encrypt
/*
|| When      Who Rel      What
|| 01/27/14  PLC 10.576  Added 
*/

if exists(Select 1 from tMediaAffiliate (nolock) Where CompanyKey = @CompanyKey and AffiliateID = @AffiliateID and MediaAffiliateKey <> @MediaAffiliateKey)
	Return -1

IF 	@MediaAffiliateKey <= 0
	BEGIN
		INSERT tMediaAffiliate
			(
			CompanyKey,
			AffiliateID,
			AffiliateName,
			Active
			)

		VALUES
			(
			@CompanyKey,
			@AffiliateID,
			@AffiliateName,
			@Active
			)
		
		RETURN @@IDENTITY
	END
ELSE
	BEGIN
		UPDATE
			tMediaAffiliate
		SET
			CompanyKey = @CompanyKey,
			AffiliateID = @AffiliateID,
			AffiliateName = @AffiliateName,
			Active = @Active
		WHERE
			MediaAffiliateKey = @MediaAffiliateKey 

		RETURN @MediaAffiliateKey
	END
GO
