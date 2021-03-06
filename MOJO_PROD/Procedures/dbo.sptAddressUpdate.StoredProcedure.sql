USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAddressUpdate]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAddressUpdate]
	@AddressKey int = NULL,
	@OwnerCompanyKey int,
	@CompanyKey int,
	@Entity varchar(50),
	@EntityKey int,
	@AddressName varchar(200),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@Active tinyint

AS  -- Encrypt

/*
|| When      Who Rel      What
|| 09/18/09  CRG 10.5.1.0 Added code to push company address changes to contacts where their LinkedCompanyAddressKey = @AddressKey
|| 06/23/14  MFT 10.5.8.1 Added insert logic
*/

IF ISNULL(@AddressKey, 0) > 0
	BEGIN
		UPDATE
			tAddress
		SET
			OwnerCompanyKey = @OwnerCompanyKey,
			CompanyKey = @CompanyKey,
			Entity = @Entity,
			EntityKey = @EntityKey,
			AddressName = @AddressName,
			Address1 = @Address1,
			Address2 = @Address2,
			Address3 = @Address3,
			City = @City,
			State = @State,
			PostalCode = @PostalCode,
			Country = @Country,
			Active = @Active
		WHERE
			AddressKey = @AddressKey 
		
		UPDATE
			tAddress
		SET
			OwnerCompanyKey = @OwnerCompanyKey,
			CompanyKey = @CompanyKey,
			AddressName = @AddressName,
			Address1 = @Address1,
			Address2 = @Address2,
			Address3 = @Address3,
			City = @City,
			State = @State,
			PostalCode = @PostalCode,
			Country = @Country,
			Active = @Active
		FROM	tAddress (nolock)
		INNER JOIN tUser u (nolock) ON tAddress.AddressKey = u.AddressKey AND u.LinkedCompanyAddressKey = @AddressKey
	END
ELSE
	BEGIN
		INSERT INTO tAddress
			(
				OwnerCompanyKey,
				CompanyKey,
				Entity,
				EntityKey,
				AddressName,
				Address1,
				Address2,
				Address3,
				City,
				State,
				PostalCode,
				Country,
				Active
			)
		VALUES
			(
				@OwnerCompanyKey,
				@CompanyKey,
				@Entity,
				@EntityKey,
				@AddressName,
				@Address1,
				@Address2,
				@Address3,
				@City,
				@State,
				@PostalCode,
				@Country,
				@Active
			)
		
		SELECT @AddressKey = SCOPE_IDENTITY()
	END
	
RETURN @AddressKey
GO
