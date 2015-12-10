USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataStationUpdate]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataStationUpdate]

	@OwnerCompanyKey int,
	@CompanyMediaKey int,
	@LinkID varchar(50),
	@StationID varchar(50),
	@VendorID varchar(50),
	@MediaLinkID varchar(100),
	@MarketLinkID varchar(100),
	@StationName varchar(250),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@MAddress1 varchar(100),
	@MAddress2 varchar(100),
	@MCity varchar(100),
	@MState varchar(50),
	@MPostalCode varchar(20)


As --Encrypt

  /*
  || When     Who Rel      What
  || 07/24/09 GHL 10.5     Inserting now addresses in tAddress
  */

declare @VendorKey int
declare @MediaMarketKey int
declare @ItemKey int
declare @AddressKey int


	select @VendorKey = CompanyKey
	  from tCompany (nolock)
	 where OwnerCompanyKey = @OwnerCompanyKey
	   and VendorID = @VendorID
	   and Vendor = 1
   
	-- check if vendor exists and add it if needed
	if @VendorKey is null
		begin
			
			insert tCompany 
		          (OwnerCompanyKey
		          ,Active
		          ,Vendor
		          ,BillableClient
		          ,LinkID
		          ,CompanyName
		          ,VendorID
		          )	
		   values (@OwnerCompanyKey
				  ,1
				  ,1
				  ,0
				  ,'BV' + @LinkID
				  ,@StationName
				  ,@VendorID
				  )
			select @VendorKey = @@IDENTITY			  				  
		
			insert tAddress 
				(OwnerCompanyKey
				,CompanyKey
				,Entity
				,EntityKey
				,AddressName
				,Address1
				,Address2
				,Address3
				,City
				,State
				,PostalCode
				,Country
				,Active)
			values	
				(@OwnerCompanyKey
				,@VendorKey -- CompanyKey
				,NULL --Entity
				,NULL --EntityKey
				,'Default' --AddressName
				,@Address1
				,@Address2
				,NULL --Address3
				,@City
				,@State
				,@PostalCode
				,NULL -- Country
				,1 --Active)	
				)
				
			select @AddressKey = @@IDENTITY
			
			update tCompany set DefaultAddressKey = @AddressKey where CompanyKey = @VendorKey
		end

	select @MediaMarketKey = MediaMarketKey 
      from tMediaMarket (nolock)
     where CompanyKey = @OwnerCompanyKey
       and LinkID = @MarketLinkID
       
   select @ItemKey = ItemKey
     from tItem (nolock)
    where CompanyKey = @OwnerCompanyKey
      and LinkID = @MediaLinkID
      and ItemType = 2

	if @CompanyMediaKey is null
		begin
			if exists(select 1 
					    from tCompanyMedia (nolock)
					   where CompanyKey = @OwnerCompanyKey
					     and StationID = @StationID
					     and MediaKind = 2)
				begin
					select @CompanyMediaKey = CompanyMediaKey 
					  from tCompanyMedia (nolock)
					 where CompanyKey = @OwnerCompanyKey
					   and StationID = @StationID
					   and MediaKind = 2
					   
					update tCompanyMedia
					   set LinkID = @LinkID
					      ,VendorKey = @VendorKey
					      ,ItemKey = @ItemKey
					      ,MediaMarketKey = @MediaMarketKey
						  ,Name = @StationName
						  ,Address1 = @Address1
						  ,Address2 = @Address2
						  ,City = @City
						  ,State = @State
						  ,PostalCode = @PostalCode
						  ,MAddress1 = @MAddress1
						  ,MAddress2 = @MAddress2
						  ,MCity = @MCity
						  ,MState = @MState
						  ,MPostalCode = @MPostalCode					   
					 where CompanyMediaKey = @CompanyMediaKey
				end
			else
				insert tCompanyMedia
				      (CompanyKey
				      ,VendorKey
				      ,MediaKind
				      ,Name
				      ,StationID
				      ,MediaMarketKey
				      ,ItemKey
				      ,Active
				      ,Address1
				      ,Address2
				      ,City
				      ,State
				      ,PostalCode
				      ,MAddress1
				      ,MAddress2
				      ,MCity
				      ,MState
				      ,MPostalCode
				      ,LinkID
				      ,Date1Days
				      ,Date2Days
				      ,Date3Days
				      ,Date4Days
				      ,Date5Days
				      ,Date6Days
				      )	
			  values  (@OwnerCompanyKey
					  ,@VendorKey
					  ,2
					  ,@StationName
					  ,@StationID
					  ,@MediaMarketKey
					  ,@ItemKey
					  ,1
					  ,@Address1
					  ,@Address2
					  ,@City
					  ,@State
					  ,@PostalCode
					  ,@MAddress1
					  ,@MAddress2
					  ,@MCity
					  ,@MState
					  ,@MPostalCode
					  ,@LinkID
					  ,0
					  ,0
					  ,0
					  ,0
					  ,0
					  ,0
					  )
		end
	else
		begin
			if exists(select 1 
			   from tCompanyMedia (nolock) 
				       where CompanyKey = @OwnerCompanyKey
				         and StationID = @StationID 
				         and CompanyMediaKey <> @CompanyMediaKey
				         and MediaKind = 2)
				return -1

				update tCompanyMedia
				   set LinkID = @LinkID
					  ,VendorKey = @VendorKey
					  ,ItemKey = @ItemKey
					  ,MediaMarketKey = @MediaMarketKey
					  ,Name = @StationName
					  ,Address1 = @Address1
					  ,Address2 = @Address2
					  ,City = @City
					  ,State = @State
					  ,PostalCode = @PostalCode
					  ,MAddress1 = @MAddress1
					  ,MAddress2 = @MAddress2
					  ,MCity = @MCity
					  ,MState = @MState
					  ,MPostalCode = @MPostalCode					   
				 where CompanyMediaKey = @CompanyMediaKey
		end
GO
