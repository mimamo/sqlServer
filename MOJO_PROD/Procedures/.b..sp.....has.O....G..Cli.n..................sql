USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGetClient]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderGetClient]

	 @PurchaseOrderKey int

AS --Encrypt

declare @CompanyKey int
declare @POKind smallint
declare @ProjectKey int
declare @MediaEstimateKey int
declare @ClientLink smallint
declare @ClientKey int


	select @CompanyKey = CompanyKey
	      ,@POKind = POKind
	      ,@ProjectKey = ProjectKey
	      ,@MediaEstimateKey = MediaEstimateKey
	  from tPurchaseOrder (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey
	 
	select @ClientLink = 
	       case
		       when @POKind = 1 then isnull(IOClientLink,1)
		       when @POKind = 2 then isnull(BCClientLink,1)
	       end
	  from tPreference (nolock)
	 where CompanyKey = @CompanyKey

	-- client via project
	if @ClientLink = 1  
		begin
			if @ProjectKey is null
		        select @ProjectKey = min(ProjectKey)
				  from tPurchaseOrderDetail (nolock)
				 where PurchaseOrderKey = @PurchaseOrderKey
				
			select @ClientKey = ClientKey
			    from tProject (nolock)
			    where ProjectKey = @ProjectKey
		end
	-- client via estimate		
	else  
		select @ClientKey = ClientKey
		  from tMediaEstimate (nolock)
		 where MediaEstimateKey = @MediaEstimateKey
		
	-- get cleint info
	select isnull(CompanyName,CustomerID) as CompanyName
	  from tCompany (nolock)
	 where CompanyKey = @ClientKey

	
	return 1
GO
