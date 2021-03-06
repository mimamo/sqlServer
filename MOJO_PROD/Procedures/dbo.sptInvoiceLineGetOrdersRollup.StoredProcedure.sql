USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineGetOrdersRollup]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineGetOrdersRollup]
	(
		@InvoiceLineKey int,
		@Type smallint,
		@Percentage decimal(24,4)
	)

AS --Encrypt

/*  Who When        Rel     What
||  GHL 04/12/2006  8.3     Changed ISNULL(cm.StationID, c.VendorID) to cm.StationID
||                          United Concepts complained that it was showing wrong Publication or Station
||                          Also causing problems with the report's groups and sorts
||  GHL 05/19/2006  8.4     Added Vendor info since Nerland did not like the change made in 83 
||  GHL 05/07/2008  8.510   (21995) Added Item as rollup
||  MFT 05/25/2010 10.5.3.0 Split out orders w/ vouchers into seperate unioned query
||  GWG 05/28/2010 10.5.3.0 Fixed query
*/
declare @Rollup INT
		,@Group1 INT
		,@Group2 INT
		,@Group3 INT
		,@Group4 INT
		,@Group5 INT

DECLARE @RollupGroupBy AS VARCHAR(1000)		-- For Group Bys
		,@Rollup1Where AS VARCHAR(1000)		-- For Where Clauses
		,@Rollup2Where AS VARCHAR(1000)
		,@Rollup3Where AS VARCHAR(1000)
		,@Rollup4Where AS VARCHAR(1000)
		,@Rollup5Where AS VARCHAR(1000)

DECLARE @SQL AS VARCHAR(1000)

IF @Type = 1
	-- IO
	SELECT @Rollup = IOHideDetails
			,@Group1 = IOGroup1 
			,@Group2 = IOGroup2
			,@Group3 = IOGroup3
			,@Group4 = IOGroup4
			,@Group5 = IOGroup5
	FROM    tInvoiceLine il (NOLOCK)
			INNER JOIN tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
			LEFT OUTER JOIN tInvoiceTemplate it (NOLOCK) ON i.InvoiceTemplateKey = it.InvoiceTemplateKey
	WHERE   il.InvoiceLineKey = @InvoiceLineKey
ELSE
	-- BC					
	SELECT @Rollup = BCHideDetails 
			,@Group1 = BCGroup1 
			,@Group2 = BCGroup2
			,@Group3 = BCGroup3
			,@Group4 = BCGroup4
			,@Group5 = BCGroup5
	FROM    tInvoiceLine il (NOLOCK)
			INNER JOIN tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
			LEFT OUTER JOIN tInvoiceTemplate it (NOLOCK) ON i.InvoiceTemplateKey = it.InvoiceTemplateKey
	WHERE   il.InvoiceLineKey = @InvoiceLineKey
	
SELECT @Rollup = ISNULL(@Rollup, 0)
		,@Group1 = ISNULL(@Group1, 0) 
		,@Group2 = ISNULL(@Group2, 0)
		,@Group3 = ISNULL(@Group3, 0)
		,@Group4 = ISNULL(@Group4, 0)
		,@Group5 = ISNULL(@Group5, 0)
				
IF @Rollup = 0
	RETURN 1		
	
declare @IOClientLink smallint
declare @BCClientLink smallint
declare @CompanyKey int

select @CompanyKey = co.CompanyKey
  from tCompany co (nolock) inner join tInvoice inv (nolock) on co.CompanyKey = inv.CompanyKey
       inner join tInvoiceLine invl (nolock) on inv.InvoiceKey = invl.InvoiceKey
 where invl.InvoiceLineKey = @InvoiceLineKey   
       
select @BCClientLink = isnull(BCClientLink,1),
       @IOClientLink = isnull(IOClientLink,1)
  from tPreference (nolock)
 where CompanyKey = @CompanyKey

Select @Percentage = @Percentage / 100

-- Temp table for the invoice lines
CREATE TABLE #IL (  pQuantity DECIMAL(24,4) NULL, pAmountBilled MONEY NULL
					,ClientDivision VARCHAR(100) NULL, ClientDivisionKey INT NULL 
					,ClientProduct VARCHAR(100) NULL, ClientProductKey INT NULL 
					,EstimateName VARCHAR(100) NULL, MediaEstimateKey INT NULL
					,MarketName VARCHAR(100) NULL, MediaMarketKey INT NULL
					,StationName VARCHAR(250) NULL, CompanyMediaKey INT NULL
					,VendorName VARCHAR(250) NULL, VendorKey INT NULL
					,ItemName VARCHAR(250) NULL, ItemKey INT NULL
					,PODate SMALLDATETIME NULL, PurchaseOrderNumber VARCHAR(30) NULL
					,LineNumber INT NULL
					)
					
-- Temp table for the rollups
CREATE TABLE #Rollup ( pQuantity DECIMAL(24,4) NULL, pAmountBilled MONEY NULL
					,ClientDivision VARCHAR(100) NULL, ClientDivisionKey INT NULL 
					,ClientProduct VARCHAR(100) NULL, ClientProductKey INT NULL 
					,EstimateName VARCHAR(100) NULL, MediaEstimateKey INT NULL
					,MarketName VARCHAR(100) NULL, MediaMarketKey INT NULL
					,StationName VARCHAR(250) NULL, CompanyMediaKey INT NULL
					,VendorName VARCHAR(250) NULL, VendorKey INT NULL
					,ItemName VARCHAR(250) NULL, ItemKey INT NULL
					,qRollup1 DECIMAL(24,4) NULL, aRollup1 MONEY NULL
					,qRollup2 DECIMAL(24,4) NULL, aRollup2 MONEY NULL
					,qRollup3 DECIMAL(24,4) NULL, aRollup3 MONEY NULL
					,qRollup4 DECIMAL(24,4) NULL, aRollup4 MONEY NULL
					,qRollup5 DECIMAL(24,4) NULL, aRollup5 MONEY NULL					
					)
					
					
if (@Type = 1 and @IOClientLink = 2) or (@Type = 2 and @BCClientLink = 2) -- link to division & product via estimate
BEGIN
	INSERT #IL
	Select
		ISNULL(pod.Quantity * @Percentage, 0) as pQuantity,
		ISNULL(pod.AmountBilled * @Percentage, 0) as pAmountBilled,
		left(cd.DivisionName,100) as ClientDivision, cd.ClientDivisionKey,
		left(cp.ProductName,100) as ClientProduct, cp.ClientProductKey,
		left(me.EstimateName,100) as EstimateName, po.MediaEstimateKey,
		left(mm.MarketName,100) as MarketName, mm.MediaMarketKey,
		cm.Name as StationName, cm.CompanyMediaKey,
		c.CompanyName as VendorName, c.CompanyKey,
		i.ItemName As ItemName, i.ItemKey,
		po.PODate, po.PurchaseOrderNumber,
		pod.LineNumber
	From
		tPurchaseOrderDetail pod (nolock) 
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tClientProduct cp (nolock) on me.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on me.ClientDivisionKey = cd.ClientDivisionKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		pod.InvoiceLineKey = @InvoiceLineKey and
		po.POKind = @Type
		and (pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
	
	INSERT #IL
	Select
		ISNULL(vd.Quantity * @Percentage, 0) as pQuantity,
		ISNULL(vd.AmountBilled * @Percentage, 0) as pAmountBilled,
		left(cd.DivisionName,100) as ClientDivision, cd.ClientDivisionKey,
		left(cp.ProductName,100) as ClientProduct, cp.ClientProductKey,
		left(me.EstimateName,100) as EstimateName, po.MediaEstimateKey,
		left(mm.MarketName,100) as MarketName, mm.MediaMarketKey,
		cm.Name as StationName, cm.CompanyMediaKey,
		c.CompanyName as VendorName, c.CompanyKey,
		i.ItemName As ItemName, i.ItemKey,
		po.PODate, po.PurchaseOrderNumber,
		pod.LineNumber
	From
		tPurchaseOrderDetail pod (nolock) 
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tClientProduct cp (nolock) on me.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on me.ClientDivisionKey = cd.ClientDivisionKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		vd.InvoiceLineKey = @InvoiceLineKey and
		po.POKind = @Type
		and (vd.Quantity <> 0 or vd.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled 
	
	Order By cm.Name, po.PODate, po.PurchaseOrderNumber, pod.LineNumber
END
else  -- link to division & product via project
BEGIN
	INSERT #IL
	Select
		ISNULL(pod.Quantity * @Percentage, 0) as pQuantity,
		ISNULL(pod.AmountBilled * @Percentage, 0) as pAmountBilled,
		left(cd.DivisionName,100) as ClientDivision, cd.ClientDivisionKey,
		left(cp.ProductName,100) as ClientProduct,cp.ClientProductKey,
		left(me.EstimateName,100) as EstimateName,po.MediaEstimateKey,
		left(mm.MarketName,100) as MarketName,mm.MediaMarketKey,
		cm.Name as StationName, cm.CompanyMediaKey,
		c.CompanyName as VendorName, c.CompanyKey,
		i.ItemName As ItemName, i.ItemKey,
		po.PODate, po.PurchaseOrderNumber,
		pod.LineNumber
	From
		tPurchaseOrderDetail pod (nolock) 
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tProject pr (nolock) on pod.ProjectKey = pr.ProjectKey
		left outer join tClientProduct cp (nolock) on pr.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on pr.ClientDivisionKey = cd.ClientDivisionKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		pod.InvoiceLineKey = @InvoiceLineKey and
		po.POKind = @Type
		and (pod.Quantity <> 0 or pod.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled
	
	INSERT #IL
	Select
		ISNULL(vd.Quantity * @Percentage, 0) as pQuantity,
		ISNULL(vd.AmountBilled * @Percentage, 0) as pAmountBilled,
		left(cd.DivisionName,100) as ClientDivision, cd.ClientDivisionKey,
		left(cp.ProductName,100) as ClientProduct,cp.ClientProductKey,
		left(me.EstimateName,100) as EstimateName,po.MediaEstimateKey,
		left(mm.MarketName,100) as MarketName,mm.MediaMarketKey,
		cm.Name as StationName, cm.CompanyMediaKey,
		c.CompanyName as VendorName, c.CompanyKey,
		i.ItemName As ItemName, i.ItemKey,
		po.PODate, po.PurchaseOrderNumber,
		pod.LineNumber
	From
		tPurchaseOrderDetail pod (nolock) 
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		inner join tCompany c (nolock) on po.VendorKey = c.CompanyKey
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
		left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
		left outer join tProject pr (nolock) on pod.ProjectKey = pr.ProjectKey
		left outer join tClientProduct cp (nolock) on pr.ClientProductKey = cp.ClientProductKey
		left outer join tClientDivision cd (nolock) on pr.ClientDivisionKey = cd.ClientDivisionKey
		left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		vd.InvoiceLineKey = @InvoiceLineKey and
		po.POKind = @Type
		and (vd.Quantity <> 0 or vd.AmountBilled <> 0) -- suppress lines with zero quantity and zero AmountBilled
	
	Order By cm.Name, po.PODate, po.PurchaseOrderNumber, pod.LineNumber
END

--SELECT * FROM #IL

SELECT @RollupGroupBy = '0' -- Just a marker for commas
IF @Rollup = 1
BEGIN
	IF @Group1 = 1
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientDivision, ClientDivisionKey'
			  ,@Rollup1Where = 'ISNULL(b.ClientDivisionKey, 0) = ISNULL(#Rollup.ClientDivisionKey, 0)'
	IF @Group1 = 2
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientProduct, ClientProductKey'
			  ,@Rollup1Where = 'ISNULL(b.ClientProductKey, 0) = ISNULL(#Rollup.ClientProductKey, 0)'
	IF @Group1 = 3
		SELECT @RollupGroupBy = @RollupGroupBy + ',EstimateName, MediaEstimateKey'
			  ,@Rollup1Where = 'ISNULL(b.MediaEstimateKey, 0) = ISNULL(#Rollup.MediaEstimateKey, 0)'
	IF @Group1 = 4
		SELECT @RollupGroupBy = @RollupGroupBy + ',MarketName, MediaMarketKey'
			  ,@Rollup1Where = 'ISNULL(b.MediaMarketKey, 0) = ISNULL(#Rollup.MediaMarketKey, 0)'		
	IF @Group1 = 5
		SELECT @RollupGroupBy = @RollupGroupBy + ',StationName, CompanyMediaKey'		 		
			  ,@Rollup1Where = 'ISNULL(b.CompanyMediaKey, 0) = ISNULL(#Rollup.CompanyMediaKey, 0)'
	IF @Group1 = 6
		SELECT @RollupGroupBy = @RollupGroupBy + ',VendorName, VendorKey'		 		
			  ,@Rollup1Where = 'ISNULL(b.VendorKey, 0) = ISNULL(#Rollup.VendorKey, 0)'
	IF @Group1 = 7
		SELECT @RollupGroupBy = @RollupGroupBy + ',ItemName, ItemKey'		 		
			  ,@Rollup1Where = 'ISNULL(b.ItemKey, 0) = ISNULL(#Rollup.ItemKey, 0)'
		
END
IF @Rollup = 1
BEGIN
	IF @Group2 = 1
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientDivision, ClientDivisionKey'
			  ,@Rollup2Where = 'ISNULL(b.ClientDivisionKey, 0) = ISNULL(#Rollup.ClientDivisionKey, 0)'
	IF @Group2 = 2
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientProduct, ClientProductKey'
			  ,@Rollup2Where = 'ISNULL(b.ClientProductKey, 0) = ISNULL(#Rollup.ClientProductKey, 0)'
	IF @Group2 = 3
		SELECT @RollupGroupBy = @RollupGroupBy + ',EstimateName, MediaEstimateKey'
			  ,@Rollup2Where = 'ISNULL(b.MediaEstimateKey, 0) = ISNULL(#Rollup.MediaEstimateKey, 0)'
	IF @Group2 = 4
		SELECT @RollupGroupBy = @RollupGroupBy + ',MarketName, MediaMarketKey'
			  ,@Rollup2Where = 'ISNULL(b.MediaMarketKey, 0) = ISNULL(#Rollup.MediaMarketKey, 0)'	
	IF @Group2 = 5
		SELECT @RollupGroupBy = @RollupGroupBy + ',StationName, CompanyMediaKey'		 		
			  ,@Rollup2Where = 'ISNULL(b.CompanyMediaKey, 0) = ISNULL(#Rollup.CompanyMediaKey, 0)'
	IF @Group2 = 6
		SELECT @RollupGroupBy = @RollupGroupBy + ',VendorName, VendorKey'		 		
			  ,@Rollup2Where = 'ISNULL(b.VendorKey, 0) = ISNULL(#Rollup.VendorKey, 0)'
	IF @Group2 = 7
		SELECT @RollupGroupBy = @RollupGroupBy + ',ItemName, ItemKey'		 		
			  ,@Rollup2Where = 'ISNULL(b.ItemKey, 0) = ISNULL(#Rollup.ItemKey, 0)'

END
IF @Rollup = 1
BEGIN
	IF @Group3 = 1
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientDivision, ClientDivisionKey'
			  ,@Rollup3Where = 'ISNULL(b.ClientDivisionKey, 0) = ISNULL(#Rollup.ClientDivisionKey, 0)'
	IF @Group3 = 2
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientProduct, ClientProductKey'
			  ,@Rollup3Where = 'ISNULL(b.ClientProductKey, 0) = ISNULL(#Rollup.ClientProductKey, 0)'
	IF @Group3 = 3
		SELECT @RollupGroupBy = @RollupGroupBy + ',EstimateName, MediaEstimateKey'
			  ,@Rollup3Where = 'ISNULL(b.MediaEstimateKey, 0) = ISNULL(#Rollup.MediaEstimateKey, 0)'
	IF @Group3 = 4
		SELECT @RollupGroupBy = @RollupGroupBy + ',MarketName, MediaMarketKey'
			  ,@Rollup3Where = 'ISNULL(b.MediaMarketKey, 0) = ISNULL(#Rollup.MediaMarketKey, 0)'
	IF @Group3 = 5
		SELECT @RollupGroupBy = @RollupGroupBy + ',StationName, CompanyMediaKey'		 		
			  ,@Rollup3Where = 'ISNULL(b.CompanyMediaKey, 0) = ISNULL(#Rollup.CompanyMediaKey, 0)'
	IF @Group3 = 6
		SELECT @RollupGroupBy = @RollupGroupBy + ',VendorName, VendorKey'		 		
			  ,@Rollup3Where = 'ISNULL(b.VendorKey, 0) = ISNULL(#Rollup.VendorKey, 0)'
	IF @Group3 = 7
		SELECT @RollupGroupBy = @RollupGroupBy + ',ItemName, ItemKey'		 		
			  ,@Rollup3Where = 'ISNULL(b.ItemKey, 0) = ISNULL(#Rollup.ItemKey, 0)'

END
IF @Rollup = 1
BEGIN
	IF @Group4 = 1
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientDivision, ClientDivisionKey'
			  ,@Rollup4Where = 'ISNULL(b.ClientDivisionKey, 0) = ISNULL(#Rollup.ClientDivisionKey, 0)'
	IF @Group4 = 2
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientProduct, ClientProductKey'
			  ,@Rollup4Where = 'ISNULL(b.ClientProductKey, 0) = ISNULL(#Rollup.ClientProductKey, 0)'
	IF @Group4 = 3
		SELECT @RollupGroupBy = @RollupGroupBy + ',EstimateName, MediaEstimateKey'
			  ,@Rollup4Where = 'ISNULL(b.MediaEstimateKey, 0) = ISNULL(#Rollup.MediaEstimateKey, 0)'
	IF @Group4 = 4
		SELECT @RollupGroupBy = @RollupGroupBy + ',MarketName, MediaMarketKey'
			  ,@Rollup4Where = 'ISNULL(b.MediaMarketKey, 0) = ISNULL(#Rollup.MediaMarketKey, 0)'
	IF @Group4 = 5
		SELECT @RollupGroupBy = @RollupGroupBy + ',StationName, CompanyMediaKey'		 		
			  ,@Rollup4Where = 'ISNULL(b.CompanyMediaKey, 0) = ISNULL(#Rollup.CompanyMediaKey, 0)'
	IF @Group4 = 6
		SELECT @RollupGroupBy = @RollupGroupBy + ',VendorName, VendorKey'		 		
			  ,@Rollup4Where = 'ISNULL(b.VendorKey, 0) = ISNULL(#Rollup.VendorKey, 0)'
	IF @Group4 = 7
		SELECT @RollupGroupBy = @RollupGroupBy + ',ItemName, ItemKey'		 		
			  ,@Rollup4Where = 'ISNULL(b.ItemKey, 0) = ISNULL(#Rollup.ItemKey, 0)'

END
IF @Rollup = 1
BEGIN
	IF @Group5 = 1
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientDivision, ClientDivisionKey'
			  ,@Rollup5Where = 'ISNULL(b.ClientDivisionKey, 0) = ISNULL(#Rollup.ClientDivisionKey, 0)'
	IF @Group5 = 2
		SELECT @RollupGroupBy = @RollupGroupBy + ',ClientProduct, ClientProductKey'
			  ,@Rollup5Where = 'ISNULL(b.ClientProductKey, 0) = ISNULL(#Rollup.ClientProductKey, 0)'
	IF @Group5 = 3
		SELECT @RollupGroupBy = @RollupGroupBy + ',EstimateName, MediaEstimateKey'
			  ,@Rollup5Where = 'ISNULL(b.MediaEstimateKey, 0) = ISNULL(#Rollup.MediaEstimateKey, 0)'
	IF @Group5 = 4
		SELECT @RollupGroupBy = @RollupGroupBy + ',MarketName, MediaMarketKey'
			  ,@Rollup5Where = 'ISNULL(b.MediaMarketKey, 0) = ISNULL(#Rollup.MediaMarketKey, 0)'
	IF @Group5 = 5
		SELECT @RollupGroupBy = @RollupGroupBy + ',StationName, CompanyMediaKey'		 		
			  ,@Rollup5Where = 'ISNULL(b.CompanyMediaKey, 0) = ISNULL(#Rollup.CompanyMediaKey, 0)'
	IF @Group5 = 6
		SELECT @RollupGroupBy = @RollupGroupBy + ',VendorName, VendorKey'		 		
			  ,@Rollup5Where = 'ISNULL(b.VendorKey, 0) = ISNULL(#Rollup.VendorKey, 0)'
	IF @Group5 = 7
		SELECT @RollupGroupBy = @RollupGroupBy + ',ItemName, ItemKey'		 		
			  ,@Rollup5Where = 'ISNULL(b.ItemKey, 0) = ISNULL(#Rollup.ItemKey, 0)'

END

-- This way we can use as many ANDs in where clauses
SELECT @Rollup1Where = ISNULL(@Rollup1Where, ' 1 = 1 ')
		,@Rollup2Where = ISNULL(@Rollup2Where, ' 1 = 1 ')
		,@Rollup3Where = ISNULL(@Rollup3Where, ' 1 = 1 ')
		,@Rollup4Where = ISNULL(@Rollup4Where, ' 1 = 1 ')
		,@Rollup5Where = ISNULL(@Rollup5Where, ' 1 = 1 ')
				
SELECT @RollupGroupBy = REPLACE (@RollupGroupBy, '0,', '') -- Remove marker
--SELECT @RollupGroupBy

SELECT @SQL = 'INSERT #Rollup (' + @RollupGroupBy + ',pQuantity, pAmountBilled)'
SELECT @SQL = @SQL + ' SELECT ' + @RollupGroupBy + ', SUM(pQuantity), SUM(pAmountBilled) '
SELECT @SQL = @SQL + ' FROM #IL '
SELECT @SQL = @SQL + ' GROUP BY ' + @RollupGroupBy

--SELECT @SQL
EXEC (@SQL)

IF @Group1 > 0
BEGIN
	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.aRollup1 = (SELECT  SUM(b.pAmountBilled) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' ) '	
	--SELECT @SQL
	EXEC (@SQL)
	
	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.qRollup1 = (SELECT  SUM(b.pQuantity) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' ) '	
	EXEC (@SQL)
	
END

IF @Group2 > 0 
BEGIN
	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.aRollup2 = (SELECT  SUM(b.pAmountBilled) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup2Where	
	SELECT @SQL = @SQL + ' ) '
	--SELECT @SQL
	EXEC (@SQL)

	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.qRollup2 = (SELECT  SUM(b.pQuantity) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup2Where	
	SELECT @SQL = @SQL + ' ) '
	EXEC (@SQL)

END

IF @Group3 > 0
BEGIN
	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.aRollup3 = (SELECT  SUM(b.pAmountBilled) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup2Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup3Where	
	SELECT @SQL = @SQL + ' ) '
	--SELECT @SQL
	EXEC (@SQL)
	
	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.qRollup3 = (SELECT  SUM(b.pQuantity) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup2Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup3Where	
	SELECT @SQL = @SQL + ' ) '
	EXEC (@SQL)
	
END


IF @Group4 > 0
BEGIN
	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.aRollup4 = (SELECT  SUM(b.pAmountBilled) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup2Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup3Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup4Where	
	SELECT @SQL = @SQL + ' ) '
	--SELECT @SQL
	EXEC (@SQL)

	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.qRollup4 = (SELECT  SUM(b.pQuantity) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup2Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup3Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup4Where	
	SELECT @SQL = @SQL + ' ) '
	EXEC (@SQL)

END

IF @Group5 > 0 
BEGIN
	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.aRollup5 = (SELECT  SUM(b.pAmountBilled) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup2Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup3Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup4Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup5Where	
	SELECT @SQL = @SQL + ' ) '
	--SELECT @SQL
	EXEC (@SQL)
	
	SELECT @SQL = ' UPDATE #Rollup SET #Rollup.qRollup5 = (SELECT  SUM(b.pQuantity) FROM #Rollup b '
	SELECT @SQL = @SQL + ' WHERE '
	SELECT @SQL = @SQL + @Rollup1Where
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup2Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup3Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup4Where	
	SELECT @SQL = @SQL + ' AND '
	SELECT @SQL = @SQL + @Rollup5Where	
	SELECT @SQL = @SQL + ' ) '
	EXEC (@SQL)	
END


SELECT * FROM #Rollup

RETURN 1
GO
