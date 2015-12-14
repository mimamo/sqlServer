USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataPubUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataPubUpdate]

	@OwnerCompanyKey int,
	@CompanyMediaKey int,
	@LinkID varchar(50),
	@StationID varchar(50),
	@VendorID varchar(50),
	@MediaLinkID varchar(100),
	@MarketLinkID varchar(100),
	@StationName varchar(250)

As --Encrypt

declare @VendorKey int
declare @MediaMarketKey int
declare @ItemKey int


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
		end

	select @MediaMarketKey = MediaMarketKey 
      from tMediaMarket (nolock)
     where CompanyKey = @OwnerCompanyKey
       and LinkID = @MarketLinkID
       
   select @ItemKey = ItemKey
     from tItem (nolock)
    where CompanyKey = @OwnerCompanyKey
      and LinkID = @MediaLinkID
      and ItemType = 1

	if @CompanyMediaKey is null
		begin
			if exists(select 1 
					    from tCompanyMedia (nolock)
					   where CompanyKey = @OwnerCompanyKey
					     and StationID = @StationID
					     and MediaKind = 1)
				begin
					select @CompanyMediaKey = CompanyMediaKey 
					  from tCompanyMedia (nolock)
					 where CompanyKey = @OwnerCompanyKey
					   and StationID = @StationID
					   and MediaKind = 1
					   
					update tCompanyMedia
					   set LinkID = @LinkID
					      ,VendorKey = @VendorKey
					      ,ItemKey = @ItemKey
					      ,MediaMarketKey = @MediaMarketKey
						  ,Name = @StationName			   
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
					  ,1
					  ,@StationName
					  ,@StationID
					  ,@MediaMarketKey
					  ,@ItemKey
					  ,1
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
				         and MediaKind = 1)
				return -1

				update tCompanyMedia
				   set LinkID = @LinkID
					  ,VendorKey = @VendorKey
					  ,ItemKey = @ItemKey
					  ,MediaMarketKey = @MediaMarketKey
					  ,Name = @StationName					   
				 where CompanyMediaKey = @CompanyMediaKey
		end
GO
