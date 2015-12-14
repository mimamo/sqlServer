USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBSalesTaxInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBSalesTaxInsert]
	@CompanyKey int,
	@SalesTaxID varchar(100),
	@Description varchar(300),
	@TaxRate money,
	@LinkID varchar(100)
	
	
AS --Encrypt


declare @RetVal int
declare @SalesTaxKey int


	select @SalesTaxKey = SalesTaxKey
	  from tSalesTax (nolock)
	 where LinkID = @LinkID
	   and CompanyKey = @CompanyKey
	 
if @SalesTaxKey is null
  begin	  
	exec @RetVal = sptSalesTaxInsert
	     @CompanyKey,
		 @SalesTaxID,
		 @SalesTaxID,
		 @Description,
		 null,
		 null,
		 null,
		 @TaxRate,
		 1,
		 null,
		 @SalesTaxKey output
	
	if @RetVal < 0
		return -1
		
	update tSalesTax
	   set LinkID = @LinkID
	 where SalesTaxKey = @SalesTaxKey
	 
  end
else
	update tSalesTax
       set SalesTaxID = @SalesTaxID,
	       Description = @Description,
	       TaxRate = @TaxRate
	 where LinkID = @LinkID           
	
	return @SalesTaxKey
GO
