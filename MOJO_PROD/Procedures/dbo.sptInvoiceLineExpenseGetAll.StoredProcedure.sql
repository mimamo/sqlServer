USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineExpenseGetAll]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceLineExpenseGetAll]
	(
		@InvoiceLineKey int,
		@Percentage decimal(24,4),
		@Mode smallint
	)

As --Encrypt

/*
|| When     Who Rel     What
|| 02/07/07 RTC 8.4.0.3 Corrected Net calculation for Misc Costs, Expense Receipts and Purchase Orders
|| 07/10/07 QMD 8.5     Expense Type reference changed to tItem
|| 10/17/08 GHL 10.010  (37490) Users want to see tExpenseReceipt.ExpenseDate
||                      on tVoucherDetail.SourceDate after they create vouchers 
|| 11/21/08 GHL 10.013  (40810) Matthiew McCarty at Media Logic found a discrepancy of 2 pennies
||                       between invoice line total and the sum of the detail amounts
||                       in case of split billing or @Percentage <> 1
||                       Calculating now a rounding error and adding it to a detail transaction
|| 04/13/10 MFT 10.5.21  Added UnitAmount and Markup calculated fields
|| 04/28/10 MFT 10.5.22  Removed media records from the 'VO' data set that are linked to PO's (now shown on the invoice in the BO/IO data sets)
|| 05/16/12 MFT 10.5.5.6 Changed all instances of ExpenseComments to use BilledComment, reverts to whatever field was previously diplayed on ISNULL
|| 12/23/14 MFT 10.5.8.7 Added tVoucher info for Spark44 enhancement (237287)
*/

Select @Percentage = @Percentage / 100

Declare @RoundingError as Decimal(24, 4)
Declare @LineTotalAmount as Decimal(24, 4)
Declare @DetailTotalAmount as Decimal(24, 4)
Declare @Type as VARCHAR(2) Select @Type = ''
Declare @KeyField as Int Select @KeyField = 0

-- Only do this for split billing
If @Percentage <> 1
Begin
	-- get the sum of amount billed, but do not round
	Select @LineTotalAmount = 
		(ISNULL((
	Select SUM(er.AmountBilled * @Percentage)
	From   tExpenseReceipt er (nolock)
	Where  er.InvoiceLineKey = @InvoiceLineKey
		),0))
		+
		(ISNULL((
	Select SUM(vd.AmountBilled * @Percentage)
	From   tVoucherDetail vd (nolock) 
	Where  vd.InvoiceLineKey = @InvoiceLineKey
		),0))
		+
		(ISNULL((
	Select SUM(mc.AmountBilled * @Percentage)
	From   tMiscCost mc (nolock) 
	Where  mc.InvoiceLineKey = @InvoiceLineKey
		),0))
		+
		(ISNULL((
	Select SUM(pod.AmountBilled * @Percentage)
	From   tPurchaseOrder po (nolock)
	Inner Join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
	Where  pod.InvoiceLineKey = @InvoiceLineKey
	And    po.POKind = 0
		),0))
 
	-- get the sum of rounded amount billed
	Select @DetailTotalAmount = 
		(ISNULL((
	Select SUM(ROUND(er.AmountBilled * @Percentage, 2))
	From   tExpenseReceipt er (nolock)
	Where  er.InvoiceLineKey = @InvoiceLineKey
		),0))
		+
		(ISNULL((
	Select SUM(ROUND(vd.AmountBilled * @Percentage, 2))
	From   tVoucherDetail vd (nolock) 
	Where  vd.InvoiceLineKey = @InvoiceLineKey
		),0))
		+
		(ISNULL((
	Select SUM(ROUND(mc.AmountBilled * @Percentage, 2))
	From   tMiscCost mc (nolock) 
	Where  mc.InvoiceLineKey = @InvoiceLineKey
		),0))
		+
		(ISNULL((
	Select SUM(ROUND(pod.AmountBilled * @Percentage, 2))
	From   tPurchaseOrder po (nolock)
	Inner Join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
	Where  pod.InvoiceLineKey = @InvoiceLineKey
	And    po.POKind = 0
		),0))

	-- now compare the round of the sums to the sum of the rounds
	Select @RoundingError = ROUND(ISNULL(@LineTotalAmount, 0), 2) - ISNULL(@DetailTotalAmount, 0)

	If @RoundingError <> 0 
	Begin

		select @KeyField = er.ExpenseReceiptKey
		From   tExpenseReceipt er (nolock)
		Where  er.InvoiceLineKey = @InvoiceLineKey

		If @@ROWCOUNT <> 0
			Select @Type = 'ER'

		IF @Type = ''
		Begin
			Select @KeyField = mc.MiscCostKey
			From   tMiscCost mc (nolock)
			Where  mc.InvoiceLineKey = @InvoiceLineKey

			If @@ROWCOUNT <> 0
				Select @Type = 'MC'
		End

		IF @Type = ''
		Begin
			Select @KeyField = vd.VoucherDetailKey
			From   tVoucherDetail vd (nolock)
			Where  vd.InvoiceLineKey = @InvoiceLineKey

			If @@ROWCOUNT <> 0
				Select @Type = 'VO'
		End

		IF @Type = ''
		Begin
			Select @KeyField = pod.PurchaseOrderDetailKey
			From   tPurchaseOrder po (nolock)
			Inner Join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey 
			Where  pod.InvoiceLineKey = @InvoiceLineKey
			And    po.POKind = 0

			If @@ROWCOUNT <> 0
				Select @Type = 'PO'
		End
	End -- Rounding error
End -- Split Billing

if @Mode = 1
BEGIN
	Select 
		'ER' as Type,
		er.ExpenseReceiptKey as KeyField,
		er.ExpenseDate as ExpenseDate,
		er.ActualQty * @Percentage as Quantity, 
		er.ActualUnitCost * @Percentage as UnitCost,
		er.Description as ExpenseDescription, 
		ISNULL(er.BilledComment, er.Comments) as ExpenseComments, 
		case when @Percentage = 1 then er.AmountBilled 
		else
		case when @Type = 'ER' and er.ExpenseReceiptKey = @KeyField 
			then (ROUND(er.AmountBilled * @Percentage, 2)) + @RoundingError
			else (ROUND(er.AmountBilled * @Percentage, 2))
			end 
		end as AmountBilled,
		CASE er.ActualQty * @Percentage WHEN 0 THEN 0 ELSE
			(case when @Type = 'ER' and er.ExpenseReceiptKey = @KeyField 
						then (ROUND(er.AmountBilled * @Percentage, 2)) + @RoundingError
						else (ROUND(er.AmountBilled * @Percentage, 2))
			end) / (er.ActualQty * @Percentage)
			END AS UnitAmount,
		er.ActualCost * @Percentage As Net,
		CASE WHEN
			CASE er.ActualCost * @Percentage WHEN 0 THEN 0 ELSE
				case when @Percentage = 1 then er.AmountBilled 
				else
					case when @Type = 'ER' and er.ExpenseReceiptKey = @KeyField 
						then (ROUND(er.AmountBilled * @Percentage, 2)) + @RoundingError
						else (ROUND(er.AmountBilled * @Percentage, 2))
					end 
				end / (er.ActualCost * @Percentage) END <> 0
			THEN
				(CASE er.ActualCost * @Percentage WHEN 0 THEN 0 ELSE
									case when @Percentage = 1 then er.AmountBilled 
									else
										case when @Type = 'ER' and er.ExpenseReceiptKey = @KeyField 
											then (ROUND(er.AmountBilled * @Percentage, 2)) + @RoundingError
											else (ROUND(er.AmountBilled * @Percentage, 2))
										end 
					end / (er.ActualCost * @Percentage) END - 1) * 100
			ELSE
				CASE er.ActualCost * @Percentage WHEN 0 THEN 0 ELSE
					case when @Percentage = 1 then er.AmountBilled 
					else
						case when @Type = 'ER' and er.ExpenseReceiptKey = @KeyField 
							then (ROUND(er.AmountBilled * @Percentage, 2)) + @RoundingError
							else (ROUND(er.AmountBilled * @Percentage, 2))
						end 
					end / (er.ActualCost * @Percentage) END
			END AS Markup,
		i.ItemName AS ItemDescription,
		NULL AS VendorName,
		NULL AS VoucherDate,
		NULL AS VoucherID,
		NULL AS VoucherTotal
	From
		tExpenseReceipt er (nolock)
		left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
	Where
		er.InvoiceLineKey = @InvoiceLineKey

	UNION ALL

	Select
		'MC' as Type,
		mc.MiscCostKey as KeyField,
		mc.ExpenseDate as ExpenseDate,
		mc.Quantity * @Percentage as Quantity,
		mc.UnitCost * @Percentage as UnitCost,
		mc.ShortDescription as ExpenseDescription,
		ISNULL(mc.BilledComment, mc.LongDescription) as ExpenseComments,
		case when @Percentage = 1 then mc.AmountBilled 
		else
		case when @Type = 'MC' and mc.MiscCostKey = @KeyField 
			then (ROUND(mc.AmountBilled * @Percentage, 2)) + @RoundingError
			else (ROUND(mc.AmountBilled * @Percentage, 2))
		end
		end as AmountBilled,
		CASE mc.Quantity * @Percentage WHEN 0 THEN 0 ELSE
			case when @Percentage = 1 then mc.AmountBilled 
					else
					case when @Type = 'MC' and mc.MiscCostKey = @KeyField 
						then (ROUND(mc.AmountBilled * @Percentage, 2)) + @RoundingError
						else (ROUND(mc.AmountBilled * @Percentage, 2))
					end
			end / (mc.Quantity * @Percentage)
			END AS UnitAmount,
		mc.TotalCost * @Percentage As Net,
		CASE WHEN
			CASE mc.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
				case when @Percentage = 1 then mc.AmountBilled 
				else
					case when @Type = 'MC' and mc.MiscCostKey = @KeyField 
						then (ROUND(mc.AmountBilled * @Percentage, 2)) + @RoundingError
						else (ROUND(mc.AmountBilled * @Percentage, 2))
					end
				end / (mc.TotalCost * @Percentage) END <> 0
			THEN
				(CASE mc.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
					case when @Percentage = 1 then mc.AmountBilled 
					else
						case when @Type = 'MC' and mc.MiscCostKey = @KeyField 
							then (ROUND(mc.AmountBilled * @Percentage, 2)) + @RoundingError
							else (ROUND(mc.AmountBilled * @Percentage, 2))
						end
					end / (mc.TotalCost * @Percentage) END - 1) * 100
			ELSE
				CASE mc.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
					case when @Percentage = 1 then mc.AmountBilled 
					else
						case when @Type = 'MC' and mc.MiscCostKey = @KeyField 
							then (ROUND(mc.AmountBilled * @Percentage, 2)) + @RoundingError
							else (ROUND(mc.AmountBilled * @Percentage, 2))
						end
					end / (mc.TotalCost * @Percentage) END
			END AS Markup,
		i.ItemName AS ItemDescription,
		NULL AS VendorName,
		NULL AS VoucherDate,
		NULL AS VoucherID,
		NULL AS VoucherTotal
	from
		tMiscCost mc (nolock)
		left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
	Where
		mc.InvoiceLineKey = @InvoiceLineKey
		
	UNION ALL

	Select
		'VO' as Type,
		vd.VoucherDetailKey as KeyField,
		Isnull(vd.SourceDate, v.InvoiceDate)  as ExpenseDate,
		vd.Quantity * @Percentage as Quantity,
		vd.UnitCost * @Percentage as UnitCost,
		vd.ShortDescription as ExpenseDescription,
		vd.BilledComment as ExpenseComments,
		case when @Percentage = 1 then vd.AmountBilled 
		else
		case when @Type = 'VO' and vd.VoucherDetailKey = @KeyField 
			then (ROUND(vd.AmountBilled * @Percentage, 2)) + @RoundingError
			else (ROUND(vd.AmountBilled * @Percentage, 2))
		end
		end as AmountBilled,
		CASE vd.Quantity * @Percentage WHEN 0 THEN 0 ELSE
			case when @Percentage = 1 then vd.AmountBilled 
					else
					case when @Type = 'VO' and vd.VoucherDetailKey = @KeyField 
						then (ROUND(vd.AmountBilled * @Percentage, 2)) + @RoundingError
						else (ROUND(vd.AmountBilled * @Percentage, 2))
					end
			end / (vd.Quantity * @Percentage)
			END AS UnitAmount,
		vd.TotalCost * @Percentage As Net,
		CASE WHEN
			CASE vd.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
				case when @Percentage = 1 then vd.AmountBilled 
				else
					case when @Type = 'VO' and vd.VoucherDetailKey = @KeyField 
						then (ROUND(vd.AmountBilled * @Percentage, 2)) + @RoundingError
						else (ROUND(vd.AmountBilled * @Percentage, 2))
					end
				end / (vd.TotalCost * @Percentage) END <> 0
			THEN
				(CASE vd.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
					case when @Percentage = 1 then vd.AmountBilled 
					else
						case when @Type = 'VO' and vd.VoucherDetailKey = @KeyField 
							then (ROUND(vd.AmountBilled * @Percentage, 2)) + @RoundingError
							else (ROUND(vd.AmountBilled * @Percentage, 2))
						end
					end / (vd.TotalCost * @Percentage) END - 1) * 100
			ELSE
				CASE vd.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
					case when @Percentage = 1 then vd.AmountBilled 
					else
						case when @Type = 'VO' and vd.VoucherDetailKey = @KeyField 
							then (ROUND(vd.AmountBilled * @Percentage, 2)) + @RoundingError
							else (ROUND(vd.AmountBilled * @Percentage, 2))
						end
					end / (vd.TotalCost * @Percentage) END
			END AS Markup,
		i.ItemName AS ItemDescription,
		CompanyName AS VendorName,
		InvoiceDate AS VoucherDate,
		VoucherID,
		VoucherTotal
	from
		tVoucher v (nolock)
		INNER JOIN tCompany c (nolock) ON v.VendorKey = c.CompanyKey
		INNER JOIN tVoucherDetail vd (nolock) on
			v.VoucherKey = vd.VoucherKey
		left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
		left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		left outer join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where
		vd.InvoiceLineKey = @InvoiceLineKey AND
		(vd.PurchaseOrderDetailKey IS NULL OR po.POKind = 0)
		
	UNION ALL

	Select
		'PO' as Type,
		pod.PurchaseOrderDetailKey as KeyField,
		po.PODate as ExpenseDate,
		pod.Quantity * @Percentage as Quantity,
		pod.UnitCost * @Percentage as UnitCost,
		pod.ShortDescription as ExpenseDescription,
		ISNULL(pod.BilledComment, pod.LongDescription) as ExpenseComments,
		case when @Percentage = 1 then pod.AmountBilled 
		else
		case when @Type = 'PO' and pod.PurchaseOrderDetailKey = @KeyField 
			then (ROUND(pod.AmountBilled * @Percentage, 2)) + @RoundingError
			else (ROUND(pod.AmountBilled * @Percentage, 2))
		end 
		end as AmountBilled,
		CASE pod.Quantity * @Percentage WHEN 0 THEN 0 ELSE
			case when @Percentage = 1 then pod.AmountBilled 
					else
					case when @Type = 'PO' and pod.PurchaseOrderDetailKey = @KeyField 
						then (ROUND(pod.AmountBilled * @Percentage, 2)) + @RoundingError
						else (ROUND(pod.AmountBilled * @Percentage, 2))
					end 
			end / (pod.Quantity * @Percentage)
			END AS UnitAmount,
		pod.TotalCost * @Percentage As Net,
		CASE WHEN
			CASE pod.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
				case when @Percentage = 1 then pod.AmountBilled 
				else
					case when @Type = 'PO' and pod.PurchaseOrderDetailKey = @KeyField 
						then (ROUND(pod.AmountBilled * @Percentage, 2)) + @RoundingError
						else (ROUND(pod.AmountBilled * @Percentage, 2))
					end 
				end / (pod.TotalCost * @Percentage) END <> 0
			THEN
				(CASE pod.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
					case when @Percentage = 1 then pod.AmountBilled 
					else
						case when @Type = 'PO' and pod.PurchaseOrderDetailKey = @KeyField 
							then (ROUND(pod.AmountBilled * @Percentage, 2)) + @RoundingError
							else (ROUND(pod.AmountBilled * @Percentage, 2))
						end 
				end / (pod.TotalCost * @Percentage) END - 1) * 100
			ELSE
				CASE pod.TotalCost * @Percentage WHEN 0 THEN 0 ELSE
					case when @Percentage = 1 then pod.AmountBilled 
					else
						case when @Type = 'PO' and pod.PurchaseOrderDetailKey = @KeyField 
							then (ROUND(pod.AmountBilled * @Percentage, 2)) + @RoundingError
							else (ROUND(pod.AmountBilled * @Percentage, 2))
						end 
				end / (pod.TotalCost * @Percentage) END
			END AS Markup,
		i.ItemName AS ItemDescription,
		NULL AS VendorName,
		NULL AS VoucherDate,
		NULL AS VoucherID,
		NULL AS VoucherTotal
	from
		tPurchaseOrder po (nolock)
		INNER JOIN tPurchaseOrderDetail pod (nolock) on
			po.PurchaseOrderKey = pod.PurchaseOrderKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		pod.InvoiceLineKey = @InvoiceLineKey and
	po.POKind = 0

END

if @Mode = 2
BEGIN

Select 
	ItemDescription,
	Sum(Quantity) as Quantity,
	Sum(AmountBilled) as AmountBilled,
	Sum(Net) as Net
	
From (

	Select 
		'ER' as Type,
		er.ExpenseReceiptKey as KeyField,
		er.ExpenseDate as ExpenseDate,
		er.ActualQty * @Percentage as Quantity, 
		er.ActualUnitCost * @Percentage as UnitCost,
		er.Description as ExpenseDescription, 
		ISNULL(er.BilledComment, er.Comments) as ExpenseComments, 
		er.AmountBilled * @Percentage as AmountBilled,
		er.ActualCost * @Percentage As Net,
		i.ItemName AS ItemDescription
	From
		tExpenseReceipt er (nolock)
		left outer join tItem i (nolock) on er.ItemKey = i.ItemKey
	Where
		er.InvoiceLineKey = @InvoiceLineKey

	UNION ALL

	Select
		'MC' as Type,
		mc.MiscCostKey as KeyField,
		mc.ExpenseDate as ExpenseDate,
		mc.Quantity * @Percentage as Quantity,
		mc.UnitCost * @Percentage as UnitCost,
		mc.ShortDescription as ExpenseDescription,
		ISNULL(mc.BilledComment, mc.LongDescription) as ExpenseComments,
		mc.AmountBilled * @Percentage as AmountBilled,
		mc.TotalCost * @Percentage As Net,
		i.ItemName AS ItemDescription
	from
		tMiscCost mc (nolock)
		left outer join tItem i (nolock) on mc.ItemKey = i.ItemKey
	Where
		mc.InvoiceLineKey = @InvoiceLineKey
		
	UNION ALL

	Select
		'VO' as Type,
		vd.VoucherDetailKey as KeyField,
		Isnull(vd.SourceDate, v.InvoiceDate) as ExpenseDate,
		vd.Quantity * @Percentage as Quantity,
		vd.UnitCost * @Percentage as UnitCost,
		vd.ShortDescription as ExpenseDescription,
		vd.BilledComment as ExpenseComments,
		vd.AmountBilled * @Percentage as AmountBilled,
		vd.TotalCost * @Percentage As Net,
		i.ItemName AS ItemDescription
	from
		tVoucher v (nolock)
		INNER JOIN tVoucherDetail vd (nolock) on
			v.VoucherKey = vd.VoucherKey
		left outer join tItem i (nolock) on vd.ItemKey = i.ItemKey
		left outer join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		left outer join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where
		vd.InvoiceLineKey = @InvoiceLineKey AND
		(vd.PurchaseOrderDetailKey IS NULL OR po.POKind = 0)
		
	UNION ALL

	Select
		'PO' as Type,
		pod.PurchaseOrderDetailKey as KeyField,
		po.PODate as ExpenseDate,
		pod.Quantity * @Percentage as Quantity,
		pod.UnitCost * @Percentage as UnitCost,
		pod.ShortDescription as ExpenseDescription,
		ISNULL(pod.BilledComment, pod.LongDescription) as ExpenseComments,
		pod.AmountBilled * @Percentage as AmountBilled,
		pod.TotalCost * @Percentage As Net,
		i.ItemName AS ItemDescription
	from
		tPurchaseOrder po (nolock)
		INNER JOIN tPurchaseOrderDetail pod (nolock) on
			po.PurchaseOrderKey = pod.PurchaseOrderKey
		left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	Where
		pod.InvoiceLineKey = @InvoiceLineKey and
	po.POKind = 0
	
	) as Detail
	
Group By
	ItemDescription

END
GO
