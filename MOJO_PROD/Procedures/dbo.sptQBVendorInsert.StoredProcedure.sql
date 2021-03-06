USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBVendorInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBVendorInsert]
(	
	@OwnerCompanyKey int,
	@CompanyName varchar(200),
	@VendorID varchar(50),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@PrimaryContactFirstName varchar(100),
	@PrimaryContactLastName varchar(100),
	@Phone varchar(50),
	@Fax varchar(50),
	@EINNumber varchar(30),
	@AltContactFirstName varchar(100),
	@AltContactLastName varchar(100),
	@Ind1099 varchar(1),
	@Comments varchar(2000),
	@AltPhone varchar(50),
	@Email varchar(100),
	@LinkID varchar(100)
)

AS --Encrypt

  /*
  || When     Who Rel       What
  || 07/24/09 GHL 10.5      Corrected update of Country
  || 02/21/11 QMD 10.5.4.1	Updated parms for sptVendorCompanyInsert & sptUserContactInsert
  */


declare @RetVal integer
declare @CompanyKey int
declare @UserKey int
declare @Type1099 smallint
declare @Box1099 varchar(10)


	select @Type1099 = 0
	select @Box1099 = null
	if @Ind1099 = '1'
		begin
			select @Type1099 = 1
			select @Box1099 = '03'
		end

	select @CompanyKey = CompanyKey
	  from tCompany (nolock)
	 where LinkID = @LinkID
	   and OwnerCompanyKey = @OwnerCompanyKey
	 
if @CompanyKey is null
  begin	 	
	exec @RetVal = sptVendorCompanyInsert
		 @CompanyName,
		 @OwnerCompanyKey,
		 @VendorID,
		 @Address1,
		 @Address2,
		 @Address3,
		 @City,
		 @State,
		 @PostalCode,
		 @Country,
		 null, --primary contact
		 1, --vendor
		 null,
		 null,
		 null,
		 @Phone,
		 @Fax,
		 1,
		 @Type1099,
		 @Box1099,
		 @EINNumber,
		 null,
		 null,
		 @Comments,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 @CompanyKey output

	
	if @RetVal < 0 
		return -1
		
	update tCompany
	   set --Country = @Country,
	       LinkID = @LinkID
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
				 null,
				 @AltPhone,
				 @Fax,
				 null,
				 null,
				 @Email,
				 null,
				 @OwnerCompanyKey,
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 1,
				 null,
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
				 null,
				 @AltPhone,
				 @Fax,
				 null,
				 null,
				 @Email,
				 null,
				 @OwnerCompanyKey,
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 1,
				 null,
				 @UserKey output	
		end
  end
else
	update tCompany
	   set CompanyName = @CompanyName,
		   VendorID = @VendorID,
		   --PostalCode = @PostalCode,
		   Phone = @Phone,
		   Fax = @Fax,
		   Type1099 = @Type1099,
		   Box1099  = @Box1099,
		   EINNumber = @EINNumber,
		   Comments = @Comments
     where CompanyKey = @CompanyKey 
     
     
	return @CompanyKey
GO
