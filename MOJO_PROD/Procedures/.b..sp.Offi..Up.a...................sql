USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeUpdate]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeUpdate]
	@OfficeKey int,
	@CompanyKey int,
	@OfficeID varchar(50),
	@OfficeName varchar(200),
	@ProjectNumPrefix varchar(20),
	@NextProjectNum int,
	@Active tinyint,
	@AddressKey int,
	@WebDavServerKey int = -1 --optional for backward compatibility

AS --Encrypt

/*
|| When     Who Rel      What
|| 01/02/09 GHL 10.015   (43206) Taking now CompanyKey in consideration when checking OfficeID
|| 12/09/09 MAS	10.6	 Added insert logic
|| 09/28/11 CRG 10.5.4.8 Added WebDavServerKey
*/
	If exists (Select 1 from tOffice (nolock) 
				where CompanyKey = @CompanyKey
				and OfficeID = @OfficeID 
				and OfficeKey <> @OfficeKey)
	RETURN - 1

IF @OfficeKey > 0
	Begin
		IF @WebDavServerKey = -1
			SELECT	@WebDavServerKey = WebDavServerKey
			FROM	tOffice (nolock)
			WHERE	OfficeKey = @OfficeKey

		UPDATE
			tOffice
		SET
			CompanyKey = @CompanyKey,
			OfficeID = @OfficeID,
			OfficeName = @OfficeName,
			ProjectNumPrefix = @ProjectNumPrefix,
			NextProjectNum = @NextProjectNum,
			Active = @Active,
			AddressKey = @AddressKey,
			WebDavServerKey = @WebDavServerKey
		WHERE
			OfficeKey = @OfficeKey 
		RETURN @OfficeKey 
	End
ELSE	
	Begin
		INSERT tOffice
			(
			CompanyKey,
			OfficeID,
			OfficeName,
			ProjectNumPrefix,
			NextProjectNum,
			Active,
			AddressKey,
			WebDavServerKey
			)

		VALUES
			(
			@CompanyKey,
			@OfficeID,
			@OfficeName,
			@ProjectNumPrefix,
			@NextProjectNum,
			@Active,
			@AddressKey,
			@WebDavServerKey
			)
		
		SELECT @OfficeKey = @@IDENTITY

		RETURN @OfficeKey
	End
GO
