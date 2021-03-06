USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataProductInsert]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataProductInsert]
	@OwnerCompanyKey int,
	@ClientID varchar(100),
	@LinkID varchar(100),
	@ProductName varchar(300),
	@ClientDivisionLinkID varchar(100)

AS --Encrypt

/*
|| 04/24/07 RTC 8.5 (8902) Allow for product to be added without a division. 
*/

declare @ClientKey int
declare @ClientDivisionKey int

	-- insure the product does not already exist
	if exists (select 1 
	             from tClientProduct cp (nolock) 
	             inner join tCompany c (nolock) on cp.CompanyKey = c.OwnerCompanyKey
	             where c.CustomerID = @ClientID
	               and cp.ClientKey = c.CompanyKey
	               and cp.ProductName = @ProductName)
	    return -1
	
	-- get ClientKey from ClientID
	select @ClientKey = CompanyKey
	  from tCompany (nolock)
	 where OwnerCompanyKey = @OwnerCompanyKey
	   and CustomerID = @ClientID
	   
	if @ClientKey is null
		return -2

	-- get ClientDivisionKey from ClientDivisionLinkID
	if @ClientDivisionLinkID is not null
		begin
			select @ClientDivisionKey = ClientDivisionKey
			from tClientDivision (nolock)
			where CompanyKey = @OwnerCompanyKey
			and LinkID = @ClientDivisionLinkID
		   
		if @ClientDivisionKey is null
			return -3
		end
	
	insert tClientProduct
		  (CompanyKey
		  ,ClientKey
		  ,ProductName
		  ,Active
		  ,LinkID
		  ,ClientDivisionKey
		  )
   values (@OwnerCompanyKey
          ,@ClientKey
          ,@ProductName
          ,1
          ,@LinkID
          ,@ClientDivisionKey
	      )

	RETURN 1
GO
