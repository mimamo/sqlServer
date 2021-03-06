USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataClientUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataClientUpdate]
(
	@OwnerCompanyKey int,
	@CompanyKey int,
	@LinkID varchar(50),
	@CompanyName varchar(200),
	@CustomerID varchar(50),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@BAddress1 varchar(100),
	@BAddress2 varchar(100),
	@BCity varchar(100),
	@BState varchar(50),
	@BPostalCode varchar(20)
)

As --Encrypt

DECLARE @AddressKey INT
	,@InsertBilling INT

if ISNULL(@CompanyKey, 0) = 0
BEGIN
	if exists(Select 1 from tCompany (nolock) 
			Where CustomerID = @CustomerID and BillableClient = 1 and OwnerCompanyKey = @OwnerCompanyKey)
	BEGIN
		Select @CompanyKey = CompanyKey from tCompany (NOLOCK) 
		Where CustomerID = @CustomerID and OwnerCompanyKey = @OwnerCompanyKey and BillableClient = 1
		Update tCompany
		Set
			LinkID = @LinkID
		Where
			CompanyKey = @CompanyKey

	END
	ELSE
	BEGIN
		Insert tCompany (OwnerCompanyKey, Active, BillableClient, Vendor, LinkID, CompanyName, CustomerID)	
		Values (@OwnerCompanyKey, 1, 1, 0, @LinkID, @CompanyName, @CustomerID)
	
		SELECT @CompanyKey = @@IDENTITY
		
		IF @Address1 IS NOT NULL OR @Address2 IS NOT NULL
		OR @City IS NOT NULL OR @State IS NOT NULL OR @PostalCode IS NOT NULL
		BEGIN
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
				NULL, -- Entity
				NULL, -- EntityKey
				'Default Address', -- @AddressName,
				@Address1,
				@Address2,
				NULL, --@Address3,
				@City,
				@State,
				@PostalCode,
				NULL, --@Country,
				1 --@Active
				)
		
			SELECT @AddressKey = @@IDENTITY
			
			-- I prefer to store it right now than later
			UPDATE tCompany SET DefaultAddressKey = @AddressKey WHERE CompanyKey = @CompanyKey 
		END

		IF @BAddress1 IS NOT NULL OR @BAddress2 IS NOT NULL
		OR @BCity IS NOT NULL OR @BState IS NOT NULL OR @BPostalCode IS NOT NULL
		BEGIN
			SELECT @InsertBilling = 0
			IF ltrim(rtrim(@Address1)) <> ltrim(rtrim(@BAddress1))
				SELECT @InsertBilling = 1
			IF ltrim(rtrim(@Address2)) <> ltrim(rtrim(@BAddress2))
				SELECT @InsertBilling = 1
			IF ltrim(rtrim(@City)) <> ltrim(rtrim(@City))
				SELECT @InsertBilling = 1
			IF ltrim(rtrim(@State)) <> ltrim(rtrim(@State))
				SELECT @InsertBilling = 1
			IF ltrim(rtrim(@PostalCode)) <> ltrim(rtrim(@PostalCode))
				SELECT @InsertBilling = 1

			IF @InsertBilling = 1
			BEGIN
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
					NULL, -- Entity
					NULL, -- EntityKey
					'Billing Address', --@AddressName,
					@BAddress1,
					@BAddress2,
					NULL, --@Address3,
					@BCity,
					@BState,
					@BPostalCode,
					NULL, --@Country,
					1 --@Active
					)
			
				SELECT @AddressKey = @@IDENTITY
				
				UPDATE tCompany SET BillingAddressKey = @AddressKey WHERE CompanyKey = @CompanyKey 
			END
			
		END

	
	END	
END
ELSE
BEGIN
	if exists(Select 1 from tCompany (nolock) 
		Where CustomerID = @CustomerID and OwnerCompanyKey = @OwnerCompanyKey and BillableClient = 1 and CompanyKey <> @CompanyKey)
		Return -2

	Update tCompany
	Set
		CompanyName = @CompanyName,
		CustomerID = @CustomerID,
		LinkID = @LinkID
	Where
		CompanyKey = @CompanyKey

	IF @Address1 IS NOT NULL OR @Address2 IS NOT NULL
	OR @City IS NOT NULL OR @State IS NOT NULL OR @PostalCode IS NOT NULL
	BEGIN
		SELECT @AddressKey = AddressKey
		FROM   tAddress (NOLOCK)
		WHERE  OwnerCompanyKey = @OwnerCompanyKey
		AND	   CompanyKey = @CompanyKey
		AND    ISNULL(Address1, '') = ISNULL(@Address1, '')
		AND    ISNULL(Address2, '') = ISNULL(@Address2, '')
		AND    ISNULL(City, '') = ISNULL(@City, '')
		AND    ISNULL(State, '') = ISNULL(@State, '')
		AND    ISNULL(PostalCode, '') = ISNULL(@PostalCode, '')
		
		IF @@ROWCOUNT = 0 
		BEGIN
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
				NULL, -- Entity
				NULL, -- EntityKey
				'Default Address', -- @AddressName,
				@Address1,
				@Address2,
				NULL, --@Address3,
				@City,
				@State,
				@PostalCode,
				NULL, --@Country,
				1 --@Active
				)
		
			SELECT @AddressKey = @@IDENTITY
		END
			
								
		UPDATE tCompany SET DefaultAddressKey = @AddressKey WHERE CompanyKey = @CompanyKey 
	END

	IF @BAddress1 IS NOT NULL OR @BAddress2 IS NOT NULL
	OR @BCity IS NOT NULL OR @BState IS NOT NULL OR @BPostalCode IS NOT NULL
	BEGIN

		SELECT @InsertBilling = 0
		IF ltrim(rtrim(@Address1)) <> ltrim(rtrim(@BAddress1))
			SELECT @InsertBilling = 1
		IF ltrim(rtrim(@Address2)) <> ltrim(rtrim(@BAddress2))
			SELECT @InsertBilling = 1
		IF ltrim(rtrim(@City)) <> ltrim(rtrim(@City))
			SELECT @InsertBilling = 1
		IF ltrim(rtrim(@State)) <> ltrim(rtrim(@State))
			SELECT @InsertBilling = 1
		IF ltrim(rtrim(@PostalCode)) <> ltrim(rtrim(@PostalCode))
			SELECT @InsertBilling = 1

		IF @InsertBilling = 1
		BEGIN
			SELECT @AddressKey = AddressKey
			FROM   tAddress (NOLOCK)
			WHERE  OwnerCompanyKey = @OwnerCompanyKey
			AND	   CompanyKey = @CompanyKey
			AND    ISNULL(Address1, '') = ISNULL(@BAddress1, '')
			AND    ISNULL(Address2, '') = ISNULL(@BAddress2, '')
			AND    ISNULL(City, '') = ISNULL(@BCity, '')
			AND    ISNULL(State, '') = ISNULL(@BState, '')
			AND    ISNULL(PostalCode, '') = ISNULL(@BPostalCode, '')
			
			IF @@ROWCOUNT = 0 
			BEGIN
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
					NULL, -- Entity
					NULL, -- EntityKey
					'Billing Address', -- @AddressName,
					@BAddress1,
					@BAddress2,
					NULL, --@Address3,
					@BCity,
					@BState,
					@BPostalCode,
					NULL, --@Country,
					1 --@Active
					)
			
				SELECT @AddressKey = @@IDENTITY
			END
												
			UPDATE tCompany SET BillingAddressKey = @AddressKey WHERE CompanyKey = @CompanyKey 
		END -- IF InsertBilling
	END -- Billing Address info not null
END -- @CompanyKey not null
GO
