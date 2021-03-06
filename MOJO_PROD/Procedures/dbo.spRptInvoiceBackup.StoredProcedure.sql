USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptInvoiceBackup]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptInvoiceBackup]
	(
		@CompanyKey int
		,@FromInvoiceNumber varchar(35)
		,@ToInvoiceNumber varchar(35)
		,@FromInvoiceDate smalldatetime
		,@ToInvoiceDate smalldatetime
		,@ClientKey INT
		,@ProjectKey INT
		,@AccountManagerKey INT
		,@IncludeLabor tinyint
		,@IncludeExpenses tinyint
		,@UserKey int = null

	)
AS --Encrypt

/*
|| When      Who Rel     What
|| 2/22/08   GHL 8.5     (21769) Instead of using vProjectCosts, querying now the 5 transaction tables
||                       to increase performance 
|| 07/23/09  RLB 10.5.0.5 (57712) Changed the Labor service join to BilledService from ServiceKey so report matches invoice
|| 11/18/09  GWG 10.5.11.3 Modified the hours and cost on labor to show billed hours and billed rate.
|| 02/05/10  RLB 10.518   (74013) will pull   billing comment field first if null will pull  comments field 
|| 05/23/11  RLB 10.544	 (111846) Added Include Labor and Expense options
|| 04/16/12  GHL 10.555  Added UserKey for UserGLCompanyAccess 
|| 09/05/13  WDF 10.572  (189174) Added VoucherID
*/
	SET NOCOUNT ON 	
                    
	IF @FromInvoiceDate IS NULL
		SELECT @FromInvoiceDate = '1/1/1990'
		
	IF @ToInvoiceDate IS NULL
		SELECT @ToInvoiceDate = '1/1/2030'
      
	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
		from tUser u (nolock)
		inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
		Where u.UserKey = @UserKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
              
    CREATE TABLE #ProjectCosts (
	InvoiceKey INT NULL
	,InvoiceLineKey INT NULL 
	
	,AccountManager VARCHAR(250) NULL
	,TypeName VARCHAR(50) NULL	
	,Description2 VARCHAR(2000) NULL -- Originally from vProjectCosts and used in the report
	,ItemName VARCHAR(250) NULL	
	,PersonItem VARCHAR(250) NULL	
	,TaskName VARCHAR(500) NULL
		
	,TransactionDate DATETIME NULL
	,Quantity DECIMAL(24, 4) NULL
	,TotalCost MONEY NULL
	,AmountBilled MONEY NULL
	,TransactionComments VARCHAR(2000) NULL 
	,VoucherID int null
	)
	                        	
	CREATE TABLE #Invoices (
	InvoiceKey INT NULL
	,InvoiceLineKey INT NULL
	,ClientName    VARCHAR(200) NULL
	,InvoiceNumber VARCHAR(35) NULL
	,InvoiceDate DATETIME NULL
	,LineSubject VARCHAR(100) NULL)
	
	-- Perfom and save query in invoice table
	-- This way we do not have to do it 5 times	 
	
	 

	INSERT #Invoices (InvoiceKey,InvoiceLineKey,ClientName,InvoiceNumber,InvoiceDate,LineSubject)	
	SELECT i.InvoiceKey,il.InvoiceLineKey,cl.CompanyName,i.InvoiceNumber,i.InvoiceDate,il.LineSubject 
	FROM tInvoice i (NOLOCK)
		INNER JOIN tCompany cl (NOLOCK) 		ON i.ClientKey = cl.CompanyKey
		INNER JOIN tInvoiceLine il (NOLOCK) 	ON i.InvoiceKey = il.InvoiceKey
	WHERE  i.CompanyKey = @CompanyKey	
	AND   (@ClientKey IS NULL OR i.ClientKey = @ClientKey)  	
	AND   i.InvoiceDate BETWEEN @FromInvoiceDate AND @ToInvoiceDate
	AND   (@FromInvoiceNumber IS NULL OR i.InvoiceNumber >= @FromInvoiceNumber)
	AND   (@ToInvoiceNumber IS NULL OR i.InvoiceNumber <= @ToInvoiceNumber)
	AND (@RestrictToGLCompany = 0 
		OR i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) 
		)
	
if @IncludeLabor = 1
	BEGIN
			-- Now get the transactions using the invoice table
		INSERT #ProjectCosts (InvoiceKey, InvoiceLineKey
				,AccountManager, TypeName, Description2, ItemName, PersonItem, TaskName  
				,TransactionDate, Quantity,TotalCost, AmountBilled, TransactionComments, VoucherID)
		Select  i.InvoiceKey, i.InvoiceLineKey
				,isnull(am.FirstName, '') + ' ' + isnull(am.LastName, '')
				,'Labor'							-- TypeName
				,ta.TaskName						-- Description2
				,s.Description						-- ItemName
				,u.FirstName + ' ' + u.LastName		-- PersonItem
				,ta.TaskName						-- TaskName
			
				,t.WorkDate
				,t.BilledHours
				,ROUND(t.BilledHours * t.BilledRate, 2)
				,ROUND(BilledHours * BilledRate, 2)
				,isnull(t.BilledComment, t.Comments)
				,null
				
		FROM   #Invoices i
			INNER JOIN tTime t (NOLOCK)				ON i.InvoiceLineKey = t.InvoiceLineKey
  			INNER JOIN tUser u (NOLOCK)				ON t.UserKey = u.UserKey
			LEFT OUTER JOIN tProject p (NOLOCK) 	ON t.ProjectKey = p.ProjectKey 
			LEFT OUTER JOIN tUser am (NOLOCK) 		ON p.AccountManager = am.UserKey
  			LEFT OUTER JOIN tTask ta (NOLOCK)		ON t.TaskKey = ta.TaskKey    
  			LEFT OUTER JOIN tService s (NOLOCK)		ON t.BilledService = s.ServiceKey
		WHERE (@ProjectKey IS NULL OR t.ProjectKey = @ProjectKey)  		
		AND   (@AccountManagerKey IS NULL OR am.UserKey = @AccountManagerKey)  		
	END

if @IncludeExpenses = 1
	BEGIN	
		INSERT #ProjectCosts (InvoiceKey, InvoiceLineKey 
				,AccountManager, TypeName, Description2, ItemName, PersonItem, TaskName  
				,TransactionDate, Quantity,TotalCost, AmountBilled, TransactionComments, VoucherID)
		Select  i.InvoiceKey, i.InvoiceLineKey			
				,isnull(am.FirstName, '') + ' ' + isnull(am.LastName, '')
				,'Misc Cost'				-- TypeName
				,mc.ShortDescription		-- Description2
				,it.ItemName				-- ItemName
				,it.ItemName				-- PersonItem
				,ta.TaskName				-- TaskName
			
				,mc.ExpenseDate
				,mc.Quantity
				,mc.TotalCost
				,mc.AmountBilled
				,mc.LongDescription
				,null
		FROM   #Invoices i (NOLOCK)
			INNER JOIN tMiscCost mc (NOLOCK)		ON i.InvoiceLineKey = mc.InvoiceLineKey
			INNER JOIN tProject p (NOLOCK) 			ON mc.ProjectKey = p.ProjectKey 
			LEFT OUTER JOIN tUser am (NOLOCK) 		ON p.AccountManager = am.UserKey
  			LEFT OUTER JOIN tTask ta (NOLOCK)		ON mc.TaskKey = ta.TaskKey    
  			LEFT OUTER JOIN tItem it (NOLOCK)		ON mc.ItemKey = it.ItemKey
 		WHERE (@ProjectKey IS NULL OR mc.ProjectKey = @ProjectKey)  		
		AND   (@AccountManagerKey IS NULL OR am.UserKey = @AccountManagerKey)  		

		INSERT #ProjectCosts (InvoiceKey, InvoiceLineKey 
				,AccountManager, TypeName, Description2, ItemName, PersonItem, TaskName  
				,TransactionDate, Quantity,TotalCost, AmountBilled, TransactionComments, VoucherID)
		Select  i.InvoiceKey, i.InvoiceLineKey			
				,isnull(am.FirstName, '') + ' ' + isnull(am.LastName, '')
				,'Expense Report'			-- TypeName
				,er.Description				-- Description2
				,it.ItemName				-- ItemName
				,u.FirstName + ' ' + u.LastName		-- PersonItem
				,ta.TaskName				-- TaskName
			
				,er.ExpenseDate
				,er.ActualQty
				,er.ActualCost
				,er.AmountBilled
				,isnull(er.BilledComment, er.Comments)
				,null
		FROM   #Invoices i (NOLOCK)
			INNER JOIN tExpenseReceipt er (NOLOCK)	ON i.InvoiceLineKey = er.InvoiceLineKey
			INNER JOIN tExpenseEnvelope ee (NOLOCK)	ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
  			INNER JOIN tUser u (NOLOCK)				ON ee.UserKey = u.UserKey
			LEFT OUTER JOIN tProject p (NOLOCK) 	ON er.ProjectKey = p.ProjectKey 
			LEFT OUTER JOIN tUser am (NOLOCK) 		ON p.AccountManager = am.UserKey
  			LEFT OUTER JOIN tTask ta (NOLOCK)		ON er.TaskKey = ta.TaskKey    
  			LEFT OUTER JOIN tItem it (NOLOCK)		ON er.ItemKey = it.ItemKey
		WHERE (@ProjectKey IS NULL OR er.ProjectKey = @ProjectKey)  		
		AND   (@AccountManagerKey IS NULL OR am.UserKey = @AccountManagerKey)  		


		INSERT #ProjectCosts (InvoiceKey, InvoiceLineKey 
				,AccountManager, TypeName, Description2, ItemName, PersonItem, TaskName  
				,TransactionDate, Quantity,TotalCost, AmountBilled, TransactionComments, VoucherID)
		Select  i.InvoiceKey, i.InvoiceLineKey
				,isnull(am.FirstName, '') + ' ' + isnull(am.LastName, '')
				,'Vendor Invoice'			-- TypeName
				,'Vendor: ' + ISNULL(ve.VendorID, '?') + ' - ' + ISNULL(ve.CompanyName, '?') + ' Invoice: ' + ISNULL(rtrim(v.InvoiceNumber), '?') + ' ' 
				+ ISNULL(vd.ShortDescription, '')	-- Description2
				,it.ItemName				-- ItemName
				,it.ItemName				-- PersonItem
				,ta.TaskName				-- TaskName
			
				,v.InvoiceDate
				,vd.Quantity
				,vd.TotalCost
				,vd.AmountBilled
				,vd.ShortDescription
				,v.VoucherID
		FROM   #Invoices i (NOLOCK)
			INNER JOIN tVoucherDetail vd (NOLOCK)	ON i.InvoiceLineKey = vd.InvoiceLineKey
			INNER JOIN tVoucher v (NOLOCK)			ON vd.VoucherKey = v.VoucherKey
			INNER JOIN tCompany ve (NOLOCK) 		ON v.VendorKey = ve.CompanyKey
  			LEFT OUTER JOIN tProject p (NOLOCK) 	ON vd.ProjectKey = p.ProjectKey 
			LEFT OUTER JOIN tUser am (NOLOCK) 		ON p.AccountManager = am.UserKey
  			LEFT OUTER JOIN tTask ta (NOLOCK)		ON vd.TaskKey = ta.TaskKey    
  			LEFT OUTER JOIN tItem it (NOLOCK)		ON vd.ItemKey = it.ItemKey
		WHERE (@ProjectKey IS NULL OR vd.ProjectKey = @ProjectKey)  		
		AND   (@AccountManagerKey IS NULL OR am.UserKey = @AccountManagerKey)  		
		
		INSERT #ProjectCosts (InvoiceKey, InvoiceLineKey 
				,AccountManager, TypeName, Description2, ItemName, PersonItem, TaskName  
				,TransactionDate, Quantity,TotalCost, AmountBilled, TransactionComments, VoucherID)
		Select  i.InvoiceKey, i.InvoiceLineKey
				,isnull(am.FirstName, '') + ' ' + isnull(am.LastName, '')
				,Case po.POKind 
						When 0 then 'Purchase Order'
						When 1 then 'Insertion Order'
						When 2 then 'Broadcast Order' 
				end
				,'Vendor: ' + ve.VendorID + ' - ' + ve.CompanyName + ' Order: ' + po.PurchaseOrderNumber + ' ' 
				+ ISNULL(pod.ShortDescription, '')	-- Description2
				,it.ItemName				-- ItemName
				,it.ItemName				-- PersonItem
				,ta.TaskName				-- TaskName
			
				 ,Case po.POKind 
					When 0 then po.PODate
					When 1 then pod.DetailOrderDate 
					When 2 then pod.DetailOrderDate
				  End
				,pod.Quantity
				,ROUND(pod.TotalCost, 2)
				,pod.AmountBilled
				,CAST(pod.LongDescription AS VARCHAR(2000))
				,null
		FROM   #Invoices i (NOLOCK)
			INNER JOIN tPurchaseOrderDetail pod (NOLOCK)	ON i.InvoiceLineKey = pod.InvoiceLineKey
			INNER JOIN tPurchaseOrder po (NOLOCK)			ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			INNER JOIN tCompany ve (NOLOCK) 		ON po.VendorKey = ve.CompanyKey
			LEFT OUTER JOIN tProject p (NOLOCK) 	ON pod.ProjectKey = p.ProjectKey 
			LEFT OUTER JOIN tUser am (NOLOCK) 		ON p.AccountManager = am.UserKey
  			LEFT OUTER JOIN tTask ta (NOLOCK)		ON pod.TaskKey = ta.TaskKey    
  			LEFT OUTER JOIN tItem it (NOLOCK)		ON pod.ItemKey = it.ItemKey
		WHERE (@ProjectKey IS NULL OR pod.ProjectKey = @ProjectKey)  		
		AND   (@AccountManagerKey IS NULL OR am.UserKey = @AccountManagerKey)  		
	END		
	
	SELECT i.*, pc.* 
	FROM #Invoices i
		INNER JOIN #ProjectCosts pc ON i.InvoiceKey = pc.InvoiceKey AND i.InvoiceLineKey = pc.InvoiceLineKey
		
	
	RETURN 1
GO
