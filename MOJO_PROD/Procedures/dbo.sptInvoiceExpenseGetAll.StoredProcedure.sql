USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceExpenseGetAll]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceExpenseGetAll]

	(
		@InvoiceKey int,
		@Percentage decimal(24,4),
		@Mode smallint
	)

AS --Encrypt

/*
|| When     Who Rel       What
|| 10/25/10 MFT 10.5.3.7  Created
|| 11/09/10 MFT 10.5.3.8  Exposed ExpenseDate
|| 12/10/10 MFT 10.5.3.8 Corrected to account for parent invoice
|| 01/13/14 RLB 10.5.8.7 Added tVoucher info for Spark44 enhancement (237287)
*/

CREATE TABLE #tInvoiceExpense
	(
		[Type] varchar(2),
		KeyField int,
		ExpenseDate datetime,
		Quantity decimal(24,4),
		UnitCost decimal(24,4),
		ExpenseDescription varchar(1000),
		ExpenseComments varchar(6000),
		AmountBilled decimal(24,4),
		UnitAmount decimal(24,4),
		Net decimal(24,4),
		Markup decimal(24,4),
		ItemDescription  varchar(200),
		VendorName varchar(200),
		VoucherDate datetime,
		VoucherID varchar(100),
		VoucherTotal money
	)

DECLARE @ParentInvoiceKey int
SELECT @ParentInvoiceKey = ISNULL(ParentInvoiceKey, @InvoiceKey) FROM tInvoice WHERE InvoiceKey = @InvoiceKey
DECLARE @InvoiceLineKey int
DECLARE cur cursor FAST_FORWARD FOR
	SELECT
		InvoiceLineKey
	FROM
		tInvoiceLine (nolock)
	WHERE
		InvoiceKey = @ParentInvoiceKey

OPEN cur

FETCH NEXT FROM
	cur
INTO
	@InvoiceLineKey

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO #tInvoiceExpense
		EXEC sptInvoiceLineExpenseGetAll @InvoiceLineKey, @Percentage, @Mode
	
	FETCH NEXT FROM
		cur
	INTO
		@InvoiceLineKey
END

CLOSE cur
DEALLOCATE cur

SELECT
	[Type],
	ExpenseDate,
	SUM(Quantity) AS Quantity,
	UnitCost,
	ExpenseDescription,
	ExpenseComments,
	SUM(AmountBilled) AS AmountBilled,
	SUM(UnitAmount) AS UnitAmount,
	SUM(Net) AS Net,
	Markup,
	ItemDescription
FROM
	#tInvoiceExpense
GROUP BY
	[Type],
	ExpenseDate,
	UnitCost,
	ExpenseDescription,
	ExpenseComments,
	Markup,
	ItemDescription

DROP TABLE #tInvoiceExpense
GO
