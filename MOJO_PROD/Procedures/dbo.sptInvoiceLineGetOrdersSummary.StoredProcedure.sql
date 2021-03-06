USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetOrdersSummary]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetOrdersSummary]
	(
		@InvoiceLineKey int,
		@Type smallint,
		@Percentage decimal(24,4),
		@GroupByOrder int = 0
	)

AS --Encrypt

/*  Who When        Rel     What
||  GHL 06/23/06  8.35      Clone of sptInvoiceLineGetOrders for summary lines
||  GHL 04/25/07  8.5       Added GroupByOrder param
||  MFT 01/21/09  10.0.1.7  Added VendorNameID field (concatentation of VendorID and VendorName)
||  CRG 4/6/11    10.5.4.3  (108173) Increased the size of VendorNameID in #tOrder because it caused a truncating error if VendorID and VendorName were maxed out.
*/ 
declare @IOClientLink smallint
declare @BCClientLink smallint
declare @CompanyKey int
declare @InvoiceKey int

select @CompanyKey = co.CompanyKey
       ,@InvoiceKey = invl.InvoiceKey
  from tCompany co (nolock) inner join tInvoice inv (nolock) on co.CompanyKey = inv.CompanyKey
       inner join tInvoiceLine invl (nolock) on inv.InvoiceKey = invl.InvoiceKey
 where invl.InvoiceLineKey = @InvoiceLineKey   
       
select @BCClientLink = isnull(BCClientLink,1),
       @IOClientLink = isnull(IOClientLink,1)
  from tPreference (nolock)
 where CompanyKey = @CompanyKey

Select @Percentage = @Percentage / 100

CREATE TABLE #tOrder (PurchaseOrderNumber VARCHAR(30) NULL
                          ,LineNumber INT NULL
                          ,PODate DATETIME NULL
                          ,DetailOrderDate DATETIME NULL
                          ,DetailOrderEndDate DATETIME NULL
                          ,ShortDescription  VARCHAR(200) NULL
                          ,UserDate1 DATETIME NULL
                          ,UserDate2 DATETIME NULL
                          ,UserDate3 DATETIME NULL
                          ,UserDate4 DATETIME NULL
                          ,UserDate5 DATETIME NULL
                          ,UserDate6 DATETIME NULL
                          ,OrderDays VARCHAR(50) NULL
                          ,OrderTime VARCHAR(50) NULL
                          ,OrderLength VARCHAR(50) NULL
                                              
                          ,pQuantity DECIMAL(24, 4) NULL
                          ,Quantity DECIMAL(24, 4) NULL
                          ,pUnitCost MONEY NULL
                          ,pAmountBilled MONEY NULL
                          ,StationID VARCHAR(50) NULL
                          ,StationName VARCHAR(250) NULL
                          ,MediaEstimateKey INT NULL
                          ,EstimateName VARCHAR(100) NULL
                          ,ClientProductKey INT NULL
                          ,ClientProduct VARCHAR(100) NULL
                          ,ClientDivisionKey INT NULL
                          ,ClientDivision VARCHAR(100) NULL
                          ,MediaMarketKey INT NULL
                          ,MarketName VARCHAR(100) NULL
                          ,CompanyMediaKey INT NULL
                          ,VendorName VARCHAR(100) NULL
                          ,VendorKey INT NULL
                          ,VendorID VARCHAR(50) NULL
                          ,VendorNameID VARCHAR(151) NULL)


	EXEC sptInvoiceLineGetOrdersRecursive @InvoiceKey, @InvoiceLineKey, @Type, @Percentage,
											@BCClientLink, @IOClientLink

	If @GroupByOrder = 0
		Select * from #tOrder                          
		Order By StationName, PODate, PurchaseOrderNumber, LineNumber
	Else
		-- group by order	
		Select
		PurchaseOrderNumber,
		PODate,
		StationID,
		StationName,
		MediaEstimateKey,
		EstimateName,
		MediaMarketKey,
		MarketName,
		CompanyMediaKey,
		VendorName,
		VendorKey,
		VendorID,
		VendorNameID,
		
		-- Grouped pod values
		SUM(pQuantity) as pQuantity,
		SUM(pAmountBilled) as pAmountBilled,
		CASE
			WHEN SUM(Quantity) = 0 THEN SUM(pAmountBilled) 
			ELSE SUM(pAmountBilled) / SUM(Quantity)
		END AS pUnitCost,
		MIN(DetailOrderDate) as DetailOrderDate,
		MAX(DetailOrderEndDate) as DetailOrderEndDate,
		MAX(UserDate1) as UserDate1,
		MAX(UserDate2) as UserDate2,
		MAX(UserDate3) as UserDate3,
		MAX(UserDate4) as UserDate4,
		MAX(UserDate5) as UserDate5,
		MAX(UserDate6) as UserDate6
		
	From #tOrder
	GROUP BY
		PurchaseOrderNumber,
		PODate,
		StationID,
		StationName,
		MediaEstimateKey,
		EstimateName,
		MediaMarketKey,
		MarketName,
		CompanyMediaKey,
		VendorName,
		VendorKey,
		VendorID,
		VendorNameID
	ORDER BY PurchaseOrderNumber
GO
