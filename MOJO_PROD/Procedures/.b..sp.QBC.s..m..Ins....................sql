USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBCustomerInsert]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBCustomerInsert]
(	
	@OwnerCompanyKey int,
	@CompanyName varchar(200),
	@CustomerID varchar(50),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@BAddress1 varchar(100),
	@BAddress2 varchar(100),
	@BAddress3 varchar(100),
	@BCity varchar(100),
	@BState varchar(50),
	@BPostalCode varchar(20),
	@BCountry varchar(50),
	@PrimaryContactFirstName varchar(100),
	@PrimaryContactLastName varchar(100),
	@Phone varchar(50),
	@Fax varchar(50),
	@Email varchar(100),
	@AltContactFirstName varchar(100),
	@AltContactLastName varchar(100),
	@AltPhone varchar(50),
	@AccountManagerFirstName varchar(100),
	@AccountManagerLastName varchar(100),
	@Comments varchar(2000),
	@LinkID varchar(100)
)


AS --Encrypt

/*
|| When     Who Rel			What
|| 02/21/11 QMD 10.5.4.1	Updated parms for sptCompanyInsert
*/

declare @RetVal integer
declare @CompanyKey int
declare @UserKey int
declare @BillingAddressKey int
declare @NewAddressKey int

	select @CompanyKey = CompanyKey
	  from tCompany (nolock)
	 where LinkID = @LinkID
	   and OwnerCompanyKey = @OwnerCompanyKey

if @CompanyKey is null
  begin
	exec @RetVal = sptCompanyInsert
		 @CompanyName,
		 null,
		 @CustomerID,  
		 @Address1,
		 @Address2,
		 @Address3,
		 @City,
		 @State,
		 @PostalCode,
		 @Country,
		 null, -- @PrimaryContact
		 0,
		 1,  --billable client  
		 null, -- @DefaultExpenseAccountKey
		 null, -- @DefaultSalesAccountKey
		 null, -- @GetRateFrom
		 null, -- @TimeRateSheetKey
		 null, -- @HourlyRate
		 null, -- @GetMarkupFrom
		 null, -- @ItemRateSheetKey
		 null, -- @ItemMarkup
		 null, -- @IOCommission
		 null, -- @BCCommission
		 null, -- @BAddress1
		 null, -- @BAddress2
		 null, -- @BAddress3
		 null, -- @BCity
		 null, -- @BState
		 null, -- @BPostalCode
		 null, -- @BCountry
		 null, -- @WebSite
		 @OwnerCompanyKey,
		 @Phone,  
		 @Fax,
		 1,  --active
		 0,  --locked
		 null, -- @CustomFieldKey
		 null, -- @AccountManagerKey
		 null, -- @DefaultTeamKey
		 null, -- @Type1099
		 null, -- @Box1099
		 null, -- @EINNumber
		 null, -- @CompanyTypeKey
		 null, -- @ContactOwnerKey
		 @Comments,
		 null,  -- @NextProjectNum
		 null,  -- @TermsPercent
		 null,  -- @TermsDays
		 null,  -- @TermsNet
		 null,  -- @SalesTaxKey
		 null,  -- @SalesTax2Key
		 null,  -- @InvoiceTemplateKey
		 null,  -- @EstimateTemplateKey
		 null,  -- @IOBillAt
		 null,  -- @BCBillAt
		 null,  -- @PaymentTermsKey
		 null,  -- @DefaultARLineFormat
		 null,  -- @DefaultBillingMethod
		 null,  -- @OneInvoicePer
		 null,  -- @DefaultExpensesNotIncluded
		 null,  -- @DefaultAddressKey
		 null,  -- @BillingAddressKey
		 null,  -- @Overhead
		 null,  -- @@GLCompanyKey		 
		 @CompanyKey output
		
	if @RetVal < 0 
		return -1
		
	update tCompany
	   set LinkID = @LinkID
	 where CompanyKey = @CompanyKey 
	 
	-- insert primary contact
	if @PrimaryContactFirstName is not null and @PrimaryContactLastName is not null
		begin
			exec @RetVal = sptUserContactInsert
				 @CompanyKey,
				 @PrimaryContactFirstName,
				 null,
				 @PrimaryContactLastName,
				 null,
				 @Phone,
				 @AltPhone,
				 null,
				 @Fax,
				 null,
				 null,
				 @Email,
				 null,
				 @OwnerCompanyKey,
				 null, -- @ContactMethod
				 null, -- @AutoAssign
				 null, -- @HourlyRate
				 null, -- @HourlyCost
				 null, -- @TimeApprover
				 null, -- @ExpenseApprover
				 null, -- @CustomFieldKey
				 null, -- @DepartmentKey
				 null, -- @OfficeKey
				 null, -- @RateLevel
				 null, -- @TimeZoneIndex				
				 @UserKey output	
				 
			if @RetVal = 1 and @UserKey is not null
				update tCompany
				   set PrimaryContact = @UserKey
				 where CompanyKey = @CompanyKey
		end

 
 	-- insert alternate contact
	if @AltContactFirstName is not null and @AltContactLastName is not null
		begin
			exec @RetVal = sptUserContactInsert
				 @CompanyKey,
				 @AltContactFirstName,
				 null,
				 @AltContactLastName,
				 null,
				 @Phone,
				 @AltPhone,
				 null,
				 @Fax,
				 null,
				 null,
				 null,
				 null,
				 @OwnerCompanyKey,
				 null, -- @ContactMethod
				 null, -- @AutoAssign
				 null, -- @HourlyRate
				 null, -- @HourlyCost
				 null, -- @TimeApprover
				 null, -- @ExpenseApprover
				 null, -- @CustomFieldKey
				 null, -- @DepartmentKey
				 null, -- @OfficeKey
				 null, -- @RateLevel
				 null, -- @TimeZoneIndex	
				 @UserKey output	
		end


	-- cannot retrieve Account Manager Info with current component, code not implemented 
	/*

	--insert account manager/employee if they do not exist
	select @UserKey = null
	select @UserKey = min(UserKey)
	from tUser (nolock)
	where CompanyKey = @OwnerCompanyKey
	and FirstName = @AccountManagerFirstName
	and LastName = @AccountManagerLastName

	if @UserKey is null and @AccountManagerFirstName is not null and @AccountManagerLastName is not null
		begin
			exec @RetVal = sptUserInsert
				@OwnerCompanyKey,
				@AccountManagerFirstName,
				null,
				@AccountManagerLastName,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null, 
				null,
				null,
				null,
				@UserKey output	
					
			if @RetVal = 1 and @UserKey is not null
				update tCompany
				set AccountManagerKey = @UserKey
				where CompanyKey = @CompanyKey				 
		end
	else
		if @UserKey is not null
			update tCompany
			set AccountManagerKey = @UserKey
			where CompanyKey = @CompanyKey
	*/	 
	
	-- handle billing address if different from company address
	if @Address1 <> @BAddress1
	or @Address2 <> @BAddress2
	or @Address3 <> @BAddress3
	or @City <> @BCity
	or @State <> @BState 
	or @PostalCode <> @BPostalCode
	or @Country <> @BCountry
		begin
			insert tAddress
					(
					OwnerCompanyKey,
					CompanyKey,
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

				values
					(
					@OwnerCompanyKey,		
					@CompanyKey,
					'Billing',
					@BAddress1,
					@BAddress2,
					@BAddress3,
					@BCity,
					@BState,
					@BPostalCode,
					@BCountry,
					1
					)
				
				select @NewAddressKey = @@IDENTITY
				update tCompany
				set BillingAddressKey = @NewAddressKey
				where CompanyKey = @CompanyKey	
		end
  end
else
	update tCompany
	   set CompanyName = @CompanyName,
		   CustomerID = @CustomerID,
		   Phone = @Phone,
		   Fax = @Fax,
		   Comments = @Comments
     where CompanyKey = @CompanyKey


	return @CompanyKey
GO
