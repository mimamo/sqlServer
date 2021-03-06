USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOfficeInsert]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOfficeInsert]
	@CompanyKey int,
	@OfficeID varchar(50), 
	@OfficeName varchar(200),
	@ProjectNumPrefix varchar(20),
	@NextProjectNum int,
	@Active tinyint,
	@AddressKey int,
	@oIdentity INT OUTPUT
AS --Encrypt

	If exists (Select 1 from tOffice (nolock) where OfficeID = @OfficeID and CompanyKey = @CompanyKey)
	RETURN - 1

	INSERT tOffice
		(
		CompanyKey,
		OfficeID,
		OfficeName,
		ProjectNumPrefix,
		NextProjectNum,
		Active,
		AddressKey
		)

	VALUES
		(
		@CompanyKey,
		@OfficeID,
		@OfficeName,
		@ProjectNumPrefix,
		@NextProjectNum,
		@Active,
		@AddressKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
