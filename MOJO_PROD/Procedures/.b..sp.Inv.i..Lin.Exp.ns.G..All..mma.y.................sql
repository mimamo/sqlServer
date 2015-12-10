USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineExpenseGetAllSummary]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineExpenseGetAllSummary]
	(
		@InvoiceLineKey int,
		@Percentage decimal(24,4),
		@Mode smallint -- 1 get all expenses, 2 rollup by Item Description
	)

AS -- Encrypt

	SET NOCOUNT ON
	
	Select @Percentage = @Percentage / 100
	
	DECLARE @InvoiceKey int
	SELECT @InvoiceKey = InvoiceKey FROM tInvoiceLine (NOLOCK) 
	WHERE InvoiceLineKey = @InvoiceLineKey 
	 	
	CREATE TABLE #tExpense (Type VARCHAR(5) NULL
	                        ,KeyField INT NULL
	                        ,ExpenseDate DATETIME NULL
	                        ,Quantity DECIMAL(24, 4) NULL
                            ,UnitCost MONEY NULL
                            ,ExpenseDescription VARCHAR(2000) NULL
                            ,ExpenseComments VARCHAR(2000) NULL
                            ,AmountBilled MONEY NULL
                            ,Net Money NULL
                            ,ItemDescription VARCHAR(500) NULL
                            )
                            	                         
	EXEC sptInvoiceLineExpenseGetAllRecursive @InvoiceKey, @InvoiceLineKey, @Percentage
	

	-- Will depend on @Mode 
	
	IF @Mode = 1
		SELECT * FROM #tExpense	
	ELSE
		Select 
			ItemDescription,
			Sum(Quantity) as Quantity,
			Sum(AmountBilled) as AmountBilled,
			Sum(Net) as Net
		From #tExpense
		Group By ItemDescription	
	
	RETURN 1
GO
