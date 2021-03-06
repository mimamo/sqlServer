USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAddressInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAddressInsert]
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
	@Active tinyint,
	@oIdentity INT OUTPUT
AS  -- Encrypt

	INSERT tAddress
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
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
