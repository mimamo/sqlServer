USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTravelClickAPIUpdateClient]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTravelClickAPIUpdateClient]
	@OwnerCompanyKey int,
	@CompanyName varchar(200),
	@Active tinyint,
	@Address1 varchar(100),
	@Address2 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@CustomerID varchar(50)

AS --Encrypt

/*
|| When      Who Rel     What
|| 10/23/07  CRG 8.5     (13411) Created for TravelClick API enhancement.  Uses Insert and Update SPs from the page to maintain the business rules.
|| 02/08/08  CRG 1.0.0.0 Added CreatedBy to sptCompanyMultiInsert call
*/

	DECLARE	@CompanyKey int,
			@Country varchar(100),
			@PrimaryContact int,
			@WebSite varchar(100),
			@Address3 varchar(100),
			@Phone varchar(50),
			@Fax varchar(50),
			@CompanyTypeKey int,
			@Comments varchar(2000),
			@ParentCompany tinyint,
			@ParentCompanyKey int,
			@UserDefined1 varchar(250),
			@UserDefined2 varchar(250),
			@UserDefined3 varchar(250),
			@UserDefined4 varchar(250),
			@UserDefined5 varchar(250),
			@UserDefined6 varchar(250),
			@UserDefined7 varchar(250),
			@UserDefined8 varchar(250),
			@UserDefined9 varchar(250),
			@UserDefined10 varchar(250),
			@ContactOwnerKey int,
			@DefaultAddressKey int,
			@AddressName varchar(200),
			@RetVal int,
			@CurrBillableClient tinyint	
	
	--See if company already exists with that CustomerID (also get column values to pass back into SPs)
	IF @CustomerID IS NOT NULL
		SELECT	@CompanyKey = ISNULL(c.CompanyKey, 0),
				@Country = da.Country,
				@PrimaryContact = c.PrimaryContact,
				@WebSite = c.WebSite,
				@Address3 = da.Address3,
				@Phone = c.Phone,
				@Fax = c.Fax,
				@CompanyTypeKey = c.CompanyTypeKey,
				@Comments = c.Comments,
				@ParentCompany = c.ParentCompany,
				@ParentCompanyKey = c.ParentCompanyKey,
				@UserDefined1 = c.UserDefined1,
				@UserDefined2 = c.UserDefined2,
				@UserDefined3 = c.UserDefined3,
				@UserDefined4 = c.UserDefined4,
				@UserDefined5 = c.UserDefined5,
				@UserDefined6 = c.UserDefined6,
				@UserDefined7 = c.UserDefined7,
				@UserDefined8 = c.UserDefined8,
				@UserDefined9 = c.UserDefined9,
				@UserDefined10 = c.UserDefined10,
				@ContactOwnerKey = c.ContactOwnerKey,
				@DefaultAddressKey = c.DefaultAddressKey,
				@CurrBillableClient = c.BillableClient
		FROM	tCompany c (nolock)
		   LEFT OUTER JOIN tAddress da (NOLOCK) ON c.DefaultAddressKey = da.AddressKey
		WHERE	c.CustomerID = @CustomerID
		AND 	c.OwnerCompanyKey = @OwnerCompanyKey
		AND		c.BillableClient = 1
	
	IF ISNULL(@CompanyKey, 0) = 0
	BEGIN
		--Insert a new Company
		EXEC sptCompanyMultiInsert
				@OwnerCompanyKey,
				@CompanyName,
				NULL, --@ContactOwnerKey
				@Address1,
				@Address2,
				NULL, --@Address3,
				@City,
				@State,
				@PostalCode,
				@Country,
				NULL, --@Phone,
				NULL, --@Fax,
				NULL, --@UserDefined1
				NULL, --@UserDefined2
				NULL, --@UserDefined3
				NULL, --@UserDefined4
				NULL, --@UserDefined5
				NULL, --@UserDefined6
				NULL, --@UserDefined7
				NULL, --@UserDefined8
				NULL, --@UserDefined9
				NULL, --@UserDefined10
				NULL, --@FirstName
				NULL, --@LastName
				NULL, --@Email
				NULL, --@Subject
				NULL, --@LeadStatusKey
				NULL, --@LeadStageKey
				NULL, --@StartDate
				NULL, --@Probability
				NULL, --@SaleAmount
				NULL, --@ActivitySubject
				NULL, --@ActivityDate
				NULL, --@Status
				NULL, --@Notes
				NULL, --@Created By
				@CompanyKey OUTPUT
		
		--Active is set to 1 when the Company is inserted.  If it was passed in as 0, update it.
		IF @Active = 0
			UPDATE	tCompany
			SET		Active = 0
			WHERE	CompanyKey = @CompanyKey
	END
	ELSE
	BEGIN
		--Update the Company
		IF @DefaultAddressKey > 0
			SELECT	@AddressName = AddressName
			FROM	tAddress (nolock)
			WHERE	AddressKey = @DefaultAddressKey

		EXEC @RetVal = sptCompanyUpdateInfo
				@CompanyKey ,
				@CompanyName,
				@Address1,
				@Address2,
				@Address3,
				@City,
				@State,
				@PostalCode,
				@Country,
				@PrimaryContact,
				@WebSite,
				@Phone,
				@Fax,
				@Active,
				@CompanyTypeKey,
				@Comments,
				@ParentCompany,
				@ParentCompanyKey,
				@UserDefined1,
				@UserDefined2,
				@UserDefined3,
				@UserDefined4,
				@UserDefined5,
				@UserDefined6,
				@UserDefined7,
				@UserDefined8,
				@UserDefined9,
				@UserDefined10,
				@ContactOwnerKey,
				@DefaultAddressKey,
				@AddressName

		IF @RetVal <> 1
			RETURN @RetVal
	END

	--Set the CustomerID and BillableClient flag if CustomerID was passed in.	
	IF @CustomerID IS NOT NULL
		UPDATE	tCompany
		SET		BillableClient = 1,
				CustomerID = @CustomerID
		WHERE	CompanyKey = @CompanyKey

	RETURN 1
GO
