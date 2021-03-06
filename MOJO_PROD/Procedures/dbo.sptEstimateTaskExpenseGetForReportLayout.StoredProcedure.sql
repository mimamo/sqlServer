USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseGetForReportLayout]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseGetForReportLayout]
	@EstimateKey int,
	@TaskKey int = 0
AS

/*
|| When      Who Rel      What
|| 4/7/10    CRG 10.5.2.1 Created for expense sub report in new estimate layout. Only for Tasks to begin with.
|| 05/03/10  MFT 10.5.2.2 Fixed OrderBy, Removed Entity parameters, Created summary dataset for footer
|| 08/23/10  GHL 10.5.3.4 Added handling of est type = 'By Project'  (by estimate)
|| 09/15/10  MFT 10.5.3.5 Added Task, Class tables/fields and MarkupAmount fields, corrected order for expense summaries
|| 09/22/10  MFT 10.5.3.5 Added Bold
|| 11/15/10  MFT 10.5.3.8 Fixed Taxable display (*)
|| 08/23/11  MFT 10.5.4.7 Added query to handle @EstType 4 & 5 - was just < 6 & ELSE, now <4, < 6 & ELSE
|| 09/01/11  MFT 10.5.4.7 Added Expense1 - Expense6 to support multiple quantities
|| 10/26/12  MFT 10.5.6.1 Corrected display order logic
|| 10/31/12  MFT 10.5.6.1 Added ApprovedQty1 - 6
|| 11/09/12  MFT 10.5.6.2 Corrected display order logic,
|| 03/15/13  MFT 10.5.6.6 Added LaborGross and LaborGrossSubtotals
|| 09/10/13  MFT 10.5.7.2 Corrected LaborGross subtotal error
|| 04/16/14  MFT 10.5.7.9 Added ShortDescription and LongDescription (from wt.WorkTypeName and wt.Description) to parent entity insert
|| 10/17/14  MFT 10.5.8.5 Corrected MarkupAmount calc (to use TotalCost rather than UnitCost)
*/

	-- Estimate Types
	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5
	declare @kByProject int			    select @kByProject = 6
	declare @kByTitleOnly int	        select @kByTitleOnly = 7
	declare @kBySegmentTitle int	    select @kBySegmentTitle = 8

DECLARE
	@LayoutKey int,
	@TopLevelDisplayOption int,
	@EstType int,
	@FinalOrder int,
	@EntityKey int,
	@ItemKey int

SELECT
	@LayoutKey = LayoutKey,
	@EstType = EstType
FROM tEstimate (nolock)
WHERE EstimateKey = @EstimateKey

SELECT @TopLevelDisplayOption = DisplayOption
FROM tLayoutBilling (nolock)
WHERE
	LayoutKey = @LayoutKey AND
	Entity = 'tProject' AND
	EntityKey = 0

CREATE TABLE #Expenses 
	(EstimateTaskExpenseKey int NULL,
	EstimateKey int NULL,
	TaskKey int NULL,
	TaskID varchar(30) NULL,
	TaskName varchar(500) NULL,
	ItemKey int NULL,
	VendorKey int NULL,
	ClassKey int NULL,
	ClassID varchar(50) NULL,
	ClassName varchar(200) NULL,
	ShortDescription varchar(200) NULL,
	LongDescription varchar(1000) NULL,
	ApprovedQty1 varchar(1) NULL,
	Quantity decimal(24, 4) NULL,
	UnitCost money NULL,
	UnitDescription varchar(30) NULL,
	TotalCost money NULL,
	Billable tinyint NULL,
	Markup decimal(24, 4) NULL,
	MarkupAmount money NULL,
	BillableCost money NULL,
	Taxable varchar(1) NULL,
	Taxable2 varchar(1) NULL,
	ApprovedQty2 varchar(1) NULL,
	Quantity2 decimal(24, 4) NULL,
	UnitCost2 money NULL,
	UnitDescription2 varchar(30) NULL,
	TotalCost2 money NULL,
	Markup2 decimal(24, 4) NULL,
	MarkupAmount2 money NULL,
	BillableCost2 money NULL,
	ApprovedQty3 varchar(1) NULL,
	Quantity3 decimal(24, 4) NULL,
	UnitCost3 money NULL,
	UnitDescription3 varchar(30) NULL,
	TotalCost3 money NULL,
	Markup3 decimal(24, 4) NULL,
	MarkupAmount3 money NULL,
	BillableCost3 money NULL,
	ApprovedQty4 varchar(1) NULL,
	Quantity4 decimal(24, 4) NULL,
	UnitCost4 money NULL,
	UnitDescription4 varchar(30) NULL,
	TotalCost4 money NULL,
	Markup4 decimal(24, 4) NULL,
	MarkupAmount4 money NULL,
	BillableCost4 money NULL,
	ApprovedQty5 varchar(1) NULL,
	Quantity5 decimal(24, 4) NULL,
	UnitCost5 money NULL,
	UnitDescription5 varchar(30) NULL,
	TotalCost5 money NULL,
	Markup5 decimal(24, 4) NULL,
	MarkupAmount5 money NULL,
	BillableCost5 money NULL,
	ApprovedQty6 varchar(1) NULL,
	Quantity6 decimal(24, 4) NULL,
	UnitCost6 money NULL,
	UnitDescription6 varchar(30) NULL,
	TotalCost6 money NULL,
	Markup6 decimal(24, 4) NULL,
	MarkupAmount6 money NULL,
	BillableCost6 money NULL,
	PurchaseOrderDetailKey int NULL,
	QuoteDetailKey int NULL,
	UnitRate money NULL,
	UnitRate2 money NULL,
	UnitRate3 money NULL,
	UnitRate4 money NULL,
	UnitRate5 money NULL,
	UnitRate6 money NULL,
	Height decimal(24, 4) NULL,
	Height2 decimal(24, 4) NULL,
	Height3 decimal(24, 4) NULL,
	Height4 decimal(24, 4) NULL,
	Height5 decimal(24, 4) NULL,
	Height6 decimal(24, 4) NULL,
	Width decimal(24, 4) NULL,
	Width2 decimal(24, 4) NULL,
	Width3 decimal(24, 4) NULL,
	Width4 decimal(24, 4) NULL,
	Width5 decimal(24, 4) NULL,
	Width6 decimal(24, 4) NULL,
	ConversionMultiplier decimal(24, 4) NULL,
	ConversionMultiplier2 decimal(24, 4) NULL,
	ConversionMultiplier3 decimal(24, 4) NULL,
	ConversionMultiplier4 decimal(24, 4) NULL,
	ConversionMultiplier5 decimal(24, 4) NULL,
	ConversionMultiplier6 decimal(24, 4) NULL,
	CampaignSegmentKey int NULL,
	DisplayOrder int NULL,
	FinalOrder int NULL,
	ItemName varchar(200) NULL,
	LayoutOrder int NULL,
	IndentLevel int NULL,
	Bold tinyint NULL,
	DisplayOption int NULL,
	ParentEntity varchar(50) NULL,
	ParentEntityKey int NULL,
	WorkTypeKey int NULL,
	Expense1 varchar(100) NULL,
	Expense2 varchar(100) NULL,
	Expense3 varchar(100) NULL,
	Expense4 varchar(100) NULL,
	Expense5 varchar(100) NULL,
	Expense6 varchar(100) NULL,
	LaborGross money NULL,
	LaborGrossSubtotal1 money NULL,
	LaborGrossSubtotal2 money NULL,
	LaborGrossSubtotal3 money NULL,
	LaborGrossSubtotal4 money NULL,
	LaborGrossSubtotal5 money NULL,
	LaborGrossSubtotal6 money NULL,)

-- if not by project, query tEstimateTaskExpense normally
IF @EstType in (@kByTaskOnly , @kByTaskService, @kByTaskPerson, @kByServiceOnly, @kByTitleOnly ) 
	INSERT	#Expenses
			 (EstimateKey,
			 TaskKey,
			 TaskID,
			 TaskName,
			 ItemKey,
			 VendorKey,
			 ClassKey,
			 ClassID,
			 ClassName,
			 ShortDescription,
			 LongDescription,
			 Quantity,
			 UnitCost,
			 UnitDescription,
			 TotalCost,
			 Billable,
			 Markup,
			 MarkupAmount,
			 BillableCost,
			 Taxable,
			 Taxable2,
			 Quantity2,
			 UnitCost2,
			 UnitDescription2,
			 TotalCost2,
			 Markup2,
			 MarkupAmount2,
			 BillableCost2,
			 Quantity3,
			 UnitCost3,
			 UnitDescription3,
			 TotalCost3,
			 Markup3,
			 MarkupAmount3,
			 BillableCost3,
			 Quantity4,
			 UnitCost4,
			 UnitDescription4,
			 TotalCost4,
			 Markup4,
			 MarkupAmount4,
			 BillableCost4,
			 Quantity5,
			 UnitCost5,
			 UnitDescription5,
			 TotalCost5,
			 Markup5,
			 MarkupAmount5,
			 BillableCost5,
			 Quantity6,
			 UnitCost6,
			 UnitDescription6,
			 TotalCost6,
			 Markup6,
			 MarkupAmount6,
			 BillableCost6,
			 PurchaseOrderDetailKey,
			 QuoteDetailKey,
			 UnitRate,
			 UnitRate2,
			 UnitRate3,
			 UnitRate4,
			 UnitRate5,
			 UnitRate6,
			 Height,
			 Height2,
			 Height3,
			 Height4,
			 Height5,
			 Height6,
			 Width,
			 Width2,
			 Width3,
			 Width4,
			 Width5,
			 Width6,
			 ConversionMultiplier,
			 ConversionMultiplier2,
			 ConversionMultiplier3,
			 ConversionMultiplier4,
			 ConversionMultiplier5,
			 ConversionMultiplier6,
			 CampaignSegmentKey,
			 DisplayOrder,
			 ItemName,
			 LayoutOrder,
			 IndentLevel,
			 Bold,
			 DisplayOption,
			 ParentEntity,
			 ParentEntityKey)
	SELECT ete.EstimateKey,
			 ete.TaskKey,
			 t.TaskID,
			 t.TaskName,
			 ete.ItemKey,
			 ete.VendorKey,
			 ete.ClassKey,
			 c.ClassID,
			 c.ClassName,
			 ete.ShortDescription,
			 ete.LongDescription,
			 ete.Quantity,
			 ete.UnitCost,
			 ete.UnitDescription,
			 ete.TotalCost,
			 ete.Billable,
			 ete.Markup,
			 ISNULL(ete.TotalCost, 0) * ISNULL(ete.Markup, 0) * .01,
			 ete.BillableCost,
			 CASE ete.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable,
			 CASE ete.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2,
			 ete.Quantity2,
			 ete.UnitCost2,
			 ete.UnitDescription2,
			 ete.TotalCost2,
			 ete.Markup2,
			 ISNULL(ete.TotalCost2, 0) * ISNULL(ete.Markup2, 0) * .01,
			 ete.BillableCost2,
			 ete.Quantity3,
			 ete.UnitCost3,
			 ete.UnitDescription3,
			 ete.TotalCost3,
			 ete.Markup3,
			 ISNULL(ete.TotalCost3, 0) * ISNULL(ete.Markup3, 0) * .01,
			 ete.BillableCost3,
			 ete.Quantity4,
			 ete.UnitCost4,
			 ete.UnitDescription4,
			 ete.TotalCost4,
			 ete.Markup4,
			 ISNULL(ete.TotalCost4, 0) * ISNULL(ete.Markup4, 0) * .01,
			 ete.BillableCost4,
			 ete.Quantity5,
			 ete.UnitCost5,
			 ete.UnitDescription5,
			 ete.TotalCost5,
			 ete.Markup5,
			 ISNULL(ete.TotalCost5, 0) * ISNULL(ete.Markup5, 0) * .01,
			 ete.BillableCost5,
			 ete.Quantity6,
			 ete.UnitCost6,
			 ete.UnitDescription6,
			 ete.TotalCost6,
			 ete.Markup6,
			 ISNULL(ete.TotalCost6, 0) * ISNULL(ete.Markup6, 0) * .01,
			 ete.BillableCost6,
			 ete.PurchaseOrderDetailKey,
			 ete.QuoteDetailKey,
			 ete.UnitRate,
			 ete.UnitRate2,
			 ete.UnitRate3,
			 ete.UnitRate4,
			 ete.UnitRate5,
			 ete.UnitRate6,
			 ete.Height,
			 ete.Height2,
			 ete.Height3,
			 ete.Height4,
			 ete.Height5,
			 ete.Height6,
			 ete.Width,
			 ete.Width2,
			 ete.Width3,
			 ete.Width4,
			 ete.Width5,
			 ete.Width6,
			 ete.ConversionMultiplier,
			 ete.ConversionMultiplier2,
			 ete.ConversionMultiplier3,
			 ete.ConversionMultiplier4,
			 ete.ConversionMultiplier5,
			 ete.ConversionMultiplier6,
			 ete.CampaignSegmentKey,
			 ete.DisplayOrder,
			 i.ItemName,
			 lb.LayoutOrder,
			 lb.LayoutLevel - 1,
			 0,
			 lb.DisplayOption,
			 lb.ParentEntity,
			 lb.ParentEntityKey
	FROM	tEstimateTaskExpense ete (nolock)
	INNER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
	LEFT JOIN tLayoutBilling lb (nolock) ON ete.ItemKey = lb.EntityKey AND lb.Entity = 'tItem' AND lb.LayoutKey = @LayoutKey
	LEFT JOIN tTask t (nolock) ON ete.TaskKey = t.TaskKey
	LEFT JOIN tClass c (nolock) ON ete.ClassKey = c.ClassKey
	WHERE	ete.EstimateKey = @EstimateKey
	AND		(ISNULL(ete.TaskKey, 0) = @TaskKey OR @TaskKey = -1)
ELSE IF @EstType in (@kBySegmentService, @kBySegmentTitle)
	INSERT	#Expenses
			 (EstimateKey,
			 TaskKey,
			 TaskID,
			 TaskName,
			 ItemKey,
			 VendorKey,
			 ClassKey,
			 ClassID,
			 ClassName,
			 ShortDescription,
			 LongDescription,
			 Quantity,
			 UnitCost,
			 UnitDescription,
			 TotalCost,
			 Billable,
			 Markup,
			 MarkupAmount,
			 BillableCost,
			 Taxable,
			 Taxable2,
			 Quantity2,
			 UnitCost2,
			 UnitDescription2,
			 TotalCost2,
			 Markup2,
			 MarkupAmount2,
			 BillableCost2,
			 Quantity3,
			 UnitCost3,
			 UnitDescription3,
			 TotalCost3,
			 Markup3,
			 MarkupAmount3,
			 BillableCost3,
			 Quantity4,
			 UnitCost4,
			 UnitDescription4,
			 TotalCost4,
			 Markup4,
			 MarkupAmount4,
			 BillableCost4,
			 Quantity5,
			 UnitCost5,
			 UnitDescription5,
			 TotalCost5,
			 Markup5,
			 MarkupAmount5,
			 BillableCost5,
			 Quantity6,
			 UnitCost6,
			 UnitDescription6,
			 TotalCost6,
			 Markup6,
			 MarkupAmount6,
			 BillableCost6,
			 PurchaseOrderDetailKey,
			 QuoteDetailKey,
			 UnitRate,
			 UnitRate2,
			 UnitRate3,
			 UnitRate4,
			 UnitRate5,
			 UnitRate6,
			 Height,
			 Height2,
			 Height3,
			 Height4,
			 Height5,
			 Height6,
			 Width,
			 Width2,
			 Width3,
			 Width4,
			 Width5,
			 Width6,
			 ConversionMultiplier,
			 ConversionMultiplier2,
			 ConversionMultiplier3,
			 ConversionMultiplier4,
			 ConversionMultiplier5,
			 ConversionMultiplier6,
			 CampaignSegmentKey,
			 DisplayOrder,
			 ItemName,
			 LayoutOrder,
			 IndentLevel,
			 Bold,
			 DisplayOption,
			 ParentEntity,
			 ParentEntityKey)
	SELECT ete.EstimateKey,
			 ete.TaskKey,
			 t.TaskID,
			 t.TaskName,
			 ete.ItemKey,
			 ete.VendorKey,
			 ete.ClassKey,
			 c.ClassID,
			 c.ClassName,
			 ete.ShortDescription,
			 ete.LongDescription,
			 ete.Quantity,
			 ete.UnitCost,
			 ete.UnitDescription,
			 ete.TotalCost,
			 ete.Billable,
			 ete.Markup,
			 ISNULL(ete.TotalCost, 0) * ISNULL(ete.Markup, 0) * .01,
			 ete.BillableCost,
			 CASE ete.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable,
			 CASE ete.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2,
			 ete.Quantity2,
			 ete.UnitCost2,
			 ete.UnitDescription2,
			 ete.TotalCost2,
			 ete.Markup2,
			 ISNULL(ete.TotalCost2, 0) * ISNULL(ete.Markup2, 0) * .01,
			 ete.BillableCost2,
			 ete.Quantity3,
			 ete.UnitCost3,
			 ete.UnitDescription3,
			 ete.TotalCost3,
			 ete.Markup3,
			 ISNULL(ete.TotalCost3, 0) * ISNULL(ete.Markup3, 0) * .01,
			 ete.BillableCost3,
			 ete.Quantity4,
			 ete.UnitCost4,
			 ete.UnitDescription4,
			 ete.TotalCost4,
			 ete.Markup4,
			 ISNULL(ete.TotalCost4, 0) * ISNULL(ete.Markup4, 0) * .01,
			 ete.BillableCost4,
			 ete.Quantity5,
			 ete.UnitCost5,
			 ete.UnitDescription5,
			 ete.TotalCost5,
			 ete.Markup5,
			 ISNULL(ete.TotalCost5, 0) * ISNULL(ete.Markup5, 0) * .01,
			 ete.BillableCost5,
			 ete.Quantity6,
			 ete.UnitCost6,
			 ete.UnitDescription6,
			 ete.TotalCost6,
			 ete.Markup6,
			 ISNULL(ete.TotalCost6, 0) * ISNULL(ete.Markup6, 0) * .01,
			 ete.BillableCost6,
			 ete.PurchaseOrderDetailKey,
			 ete.QuoteDetailKey,
			 ete.UnitRate,
			 ete.UnitRate2,
			 ete.UnitRate3,
			 ete.UnitRate4,
			 ete.UnitRate5,
			 ete.UnitRate6,
			 ete.Height,
			 ete.Height2,
			 ete.Height3,
			 ete.Height4,
			 ete.Height5,
			 ete.Height6,
			 ete.Width,
			 ete.Width2,
			 ete.Width3,
			 ete.Width4,
			 ete.Width5,
			 ete.Width6,
			 ete.ConversionMultiplier,
			 ete.ConversionMultiplier2,
			 ete.ConversionMultiplier3,
			 ete.ConversionMultiplier4,
			 ete.ConversionMultiplier5,
			 ete.ConversionMultiplier6,
			 ete.CampaignSegmentKey,
			 ete.DisplayOrder,
			 i.ItemName,
			 lb.LayoutOrder,
			 lb.LayoutLevel - 1,
			 0,
			 lb.DisplayOption,
			 lb.ParentEntity,
			 lb.ParentEntityKey
	FROM	tEstimateTaskExpense ete (nolock)
	INNER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
	LEFT JOIN tLayoutBilling lb (nolock) ON ete.ItemKey = lb.EntityKey AND lb.Entity = 'tItem' AND lb.LayoutKey = @LayoutKey
	LEFT JOIN tTask t (nolock) ON ete.TaskKey = t.TaskKey
	LEFT JOIN tClass c (nolock) ON ete.ClassKey = c.ClassKey
	WHERE	ete.EstimateKey = @EstimateKey
	AND		(ISNULL(lb.ParentEntityKey, 0) = @TaskKey OR @TaskKey = -1)
ELSE
	-- By Project, query tEstimateTaskExpense joining with tEstimateProject
	INSERT	#Expenses
			 (EstimateKey,
			 TaskKey,
			 TaskID,
			 TaskName,
			 ItemKey,
			 VendorKey,
			 ClassKey,
			 ClassID,
			 ClassName,
			 ShortDescription,
			 LongDescription,
			 Quantity,
			 UnitCost,
			 UnitDescription,
			 TotalCost,
			 Billable,
			 Markup,
			 MarkupAmount,
			 BillableCost,
			 Taxable,
			 Taxable2,
			 Quantity2,
			 UnitCost2,
			 UnitDescription2,
			 TotalCost2,
			 Markup2,
			 MarkupAmount2,
			 BillableCost2,
			 Quantity3,
			 UnitCost3,
			 UnitDescription3,
			 TotalCost3,
			 Markup3,
			 MarkupAmount3,
			 BillableCost3,
			 Quantity4,
			 UnitCost4,
			 UnitDescription4,
			 TotalCost4,
			 Markup4,
			 MarkupAmount4,
			 BillableCost4,
			 Quantity5,
			 UnitCost5,
			 UnitDescription5,
			 TotalCost5,
			 Markup5,
			 MarkupAmount5,
			 BillableCost5,
			 Quantity6,
			 UnitCost6,
			 UnitDescription6,
			 TotalCost6,
			 Markup6,
			 MarkupAmount6,
			 BillableCost6,
			 PurchaseOrderDetailKey,
			 QuoteDetailKey,
			 UnitRate,
			 UnitRate2,
			 UnitRate3,
			 UnitRate4,
			 UnitRate5,
			 UnitRate6,
			 Height,
			 Height2,
			 Height3,
			 Height4,
			 Height5,
			 Height6,
			 Width,
			 Width2,
			 Width3,
			 Width4,
			 Width5,
			 Width6,
			 ConversionMultiplier,
			 ConversionMultiplier2,
			 ConversionMultiplier3,
			 ConversionMultiplier4,
			 ConversionMultiplier5,
			 ConversionMultiplier6,
			 CampaignSegmentKey,
			 DisplayOrder,
			 ItemName,
			 LayoutOrder,
			 IndentLevel,
			 Bold,
			 DisplayOption,
			 ParentEntity,
			 ParentEntityKey)
	SELECT ete.EstimateKey,
			 ete.TaskKey,
			 t.TaskID,
			 t.TaskName,
			 ete.ItemKey,
			 ete.VendorKey,
			 ete.ClassKey,
			 c.ClassID,
			 c.ClassName,
			 ete.ShortDescription,
			 ete.LongDescription,
			 ete.Quantity,
			 ete.UnitCost,
			 ete.UnitDescription,
			 ete.TotalCost,
			 ete.Billable,
			 ete.Markup,
			 ISNULL(ete.TotalCost, 0) * ISNULL(ete.Markup, 0) * .01,
			 ete.BillableCost,
			 CASE ete.Taxable WHEN 1 THEN '*' ELSE NULL END AS Taxable,
			 CASE ete.Taxable2 WHEN 1 THEN '*' ELSE NULL END AS Taxable2,
			 ete.Quantity2,
			 ete.UnitCost2,
			 ete.UnitDescription2,
			 ete.TotalCost2,
			 ete.Markup2,
			 ISNULL(ete.TotalCost2, 0) * ISNULL(ete.Markup2, 0) * .01,
			 ete.BillableCost2,
			 ete.Quantity3,
			 ete.UnitCost3,
			 ete.UnitDescription3,
			 ete.TotalCost3,
			 ete.Markup3,
			 ISNULL(ete.TotalCost3, 0) * ISNULL(ete.Markup3, 0) * .01,
			 ete.BillableCost3,
			 ete.Quantity4,
			 ete.UnitCost4,
			 ete.UnitDescription4,
			 ete.TotalCost4,
			 ete.Markup4,
			 ISNULL(ete.TotalCost4, 0) * ISNULL(ete.Markup4, 0) * .01,
			 ete.BillableCost4,
			 ete.Quantity5,
			 ete.UnitCost5,
			 ete.UnitDescription5,
			 ete.TotalCost5,
			 ete.Markup5,
			 ISNULL(ete.TotalCost5, 0) * ISNULL(ete.Markup5, 0) * .01,
			 ete.BillableCost5,
			 ete.Quantity6,
			 ete.UnitCost6,
			 ete.UnitDescription6,
			 ete.TotalCost6,
			 ete.Markup6,
			 ISNULL(ete.TotalCost6, 0) * ISNULL(ete.Markup6, 0) * .01,
			 ete.BillableCost6,
			 ete.PurchaseOrderDetailKey,
			 ete.QuoteDetailKey,
			 ete.UnitRate,
			 ete.UnitRate2,
			 ete.UnitRate3,
			 ete.UnitRate4,
			 ete.UnitRate5,
			 ete.UnitRate6,
			 ete.Height,
			 ete.Height2,
			 ete.Height3,
			 ete.Height4,
			 ete.Height5,
			 ete.Height6,
			 ete.Width,
			 ete.Width2,
			 ete.Width3,
			 ete.Width4,
			 ete.Width5,
			 ete.Width6,
			 ete.ConversionMultiplier,
			 ete.ConversionMultiplier2,
			 ete.ConversionMultiplier3,
			 ete.ConversionMultiplier4,
			 ete.ConversionMultiplier5,
			 ete.ConversionMultiplier6,
			 ete.CampaignSegmentKey,
			 ete.DisplayOrder,
			 i.ItemName,
			 lb.LayoutOrder,
			 lb.LayoutLevel - 1,
			 0,
			 lb.DisplayOption,
			 lb.ParentEntity,
			 lb.ParentEntityKey
	FROM	tEstimateTaskExpense ete (nolock)
	INNER JOIN tItem i (nolock) ON ete.ItemKey = i.ItemKey
	INNER JOIN tEstimateProject ep (nolock) on ete.EstimateKey = ep.ProjectEstimateKey 
	LEFT JOIN tLayoutBilling lb (nolock) ON ete.ItemKey = lb.EntityKey AND lb.Entity = 'tItem' AND lb.LayoutKey = @LayoutKey
	LEFT JOIN tTask t (nolock) ON ete.TaskKey = t.TaskKey
	LEFT JOIN tClass c (nolock) ON ete.ClassKey = c.ClassKey
	WHERE	ep.EstimateKey = @EstimateKey
	AND		(ISNULL(ete.TaskKey, 0) = @TaskKey OR @TaskKey = -1)
	
--If all detail is to be rolled up to one row
IF @TopLevelDisplayOption = 1 
	BEGIN
		--roll up the lines to the top level or segment
		--NOT SURE HOW SEGMENTS WILL BE STORED YET, SO WILL NEED TO ADD THAT LATER...
		INSERT	#Expenses
				(ItemKey,
				ItemName,
				TotalCost,
				BillableCost,
				TotalCost2,
				BillableCost2,
				TotalCost3,
				BillableCost3,
				TotalCost4,
				BillableCost4,
				TotalCost5,
				BillableCost5,
				TotalCost6,
				BillableCost6)
		SELECT	-1,
				'Expenses',
				SUM(TotalCost),
				SUM(BillableCost),
				SUM(TotalCost2),
				SUM(BillableCost2),
				SUM(TotalCost3),
				SUM(BillableCost3),
				SUM(TotalCost4),
				SUM(BillableCost4),
				SUM(TotalCost5),
				SUM(BillableCost5),
				SUM(TotalCost6),
				SUM(BillableCost6)
		FROM	#Expenses
		
		DELETE	#Expenses
		WHERE	ItemKey >= 0
	END
ELSE
	BEGIN
		--Set the items' parent entities
		UPDATE #Expenses
		SET
			ParentEntity = lb.ParentEntity,
			ParentEntityKey = lb.ParentEntityKey
		FROM tLayoutBilling lb
		WHERE
			lb.LayoutKey = @LayoutKey AND
			#Expenses.ItemKey = lb.EntityKey AND
			lb.Entity = 'tItem'
		
		--Add the parent entities
		INSERT #Expenses
				(ItemName,
				ShortDescription,
				LongDescription,
				LayoutOrder,
				IndentLevel,
				Bold,
				DisplayOption,
				WorkTypeKey)
		SELECT DISTINCT	wt.WorkTypeName,
				wt.WorkTypeName,
				CAST(wt.Description AS varchar(1000)),
				lb.LayoutOrder,
				lb.LayoutLevel - 1,
				1,
				lb.DisplayOption,
				lb.EntityKey
		FROM #Expenses
		INNER JOIN tLayoutBilling lb (nolock) ON #Expenses.ParentEntityKey = lb.EntityKey AND #Expenses.ParentEntity = 'tWorkType' AND lb.Entity = 'tWorkType' AND lb.LayoutKey = @LayoutKey
		INNER JOIN tWorkType wt (nolock) ON lb.EntityKey = wt.WorkTypeKey
		
		--Roll up the item values to entities where their DisplayOption = 1 (no detail)
		UPDATE	#Expenses
		SET		TotalCost = s.TotalCost,
				BillableCost = s.BillableCost,
				TotalCost2 = s.TotalCost2,
				BillableCost2 = s.BillableCost2,
				TotalCost3 = s.TotalCost3,
				BillableCost3 = s.BillableCost3,
				TotalCost4 = s.TotalCost4,
				BillableCost4 = s.BillableCost4,
				TotalCost5 = s.TotalCost5,
				BillableCost5 = s.BillableCost5,
				TotalCost6 = s.TotalCost6,
				BillableCost6 = s.BillableCost6
		FROM	#Expenses parent
		INNER JOIN
				(SELECT s2.ParentEntityKey,
						SUM(s2.TotalCost) AS TotalCost,
						SUM(s2.BillableCost) AS BillableCost,
						SUM(s2.TotalCost2) AS TotalCost2,
						SUM(s2.BillableCost2) AS BillableCost2,
						SUM(s2.TotalCost3) AS TotalCost3,
						SUM(s2.BillableCost3) AS BillableCost3,
						SUM(s2.TotalCost4) AS TotalCost4,
						SUM(s2.BillableCost4) AS BillableCost4,
						SUM(s2.TotalCost5) AS TotalCost5,
						SUM(s2.BillableCost5) AS BillableCost5,
						SUM(s2.TotalCost6) AS TotalCost6,
						SUM(s2.BillableCost6) AS BillableCost6
				FROM	#Expenses s2
				WHERE	s2.ParentEntity = 'tWorkType'
				GROUP BY s2.ParentEntityKey) AS s ON s.ParentEntityKey = parent.WorkTypeKey
		WHERE	parent.DisplayOption = 1
		
		--Delete the items where their parent's DisplayOption = 1
		DELETE	#Expenses
		WHERE
			ParentEntity = 'tWorkType' AND
			ParentEntityKey IN (SELECT WorkTypeKey FROM #Expenses WHERE DisplayOption = 1)
	END
	
--Set the final order
SELECT
	@FinalOrder = 1

WHILE 1=1
	BEGIN
		SELECT TOP 1 @EntityKey = WorkTypeKey
		FROM #Expenses
		WHERE 
			ParentEntityKey IS NULL AND
			FinalOrder IS NULL
		ORDER BY
			LayoutOrder,
			DisplayOrder
		
		IF @EntityKey IS NULL
			BREAK
		
		UPDATE #Expenses
		SET FinalOrder = @FinalOrder
		WHERE WorkTypeKey = @EntityKey
		
		SELECT
			@FinalOrder = @FinalOrder + 1,
			@TaskKey = NULL,
			@ItemKey = NULL

		WHILE 1=1
			BEGIN
				SELECT TOP 1
					@TaskKey = ISNULL(TaskKey, 0),
					@ItemKey = ISNULL(ItemKey, 0)
				FROM #Expenses
				WHERE
					ParentEntity = 'tWorkType' AND
					ParentEntityKey = @EntityKey AND
					FinalOrder IS NULL
				ORDER BY
					LayoutOrder,
					DisplayOrder

				IF @TaskKey IS NULL AND @ItemKey IS NULL
					BREAK

				UPDATE #Expenses
				SET FinalOrder = @FinalOrder
				WHERE
					ISNULL(TaskKey, 0) = @TaskKey AND
					ISNULL(ItemKey, 0) = @ItemKey

				SELECT
					@FinalOrder = @FinalOrder + 1,
					@TaskKey = NULL,
					@ItemKey = NULL
			END

		SELECT @EntityKey = NULL
	END

UPDATE
	#Expenses
SET
	Expense1 = e.Expense1,
	Expense2 = e.Expense2,
	Expense3 = e.Expense3,
	Expense4 = e.Expense4,
	Expense5 = e.Expense5,
	Expense6 = e.Expense6,
	ApprovedQty1 = CASE ApprovedQty WHEN 1 THEN '*' ELSE NULL END,
	ApprovedQty2 = CASE ApprovedQty WHEN 2 THEN '*' ELSE NULL END,
	ApprovedQty3 = CASE ApprovedQty WHEN 3 THEN '*' ELSE NULL END,
	ApprovedQty4 = CASE ApprovedQty WHEN 4 THEN '*' ELSE NULL END,
	ApprovedQty5 = CASE ApprovedQty WHEN 5 THEN '*' ELSE NULL END,
	ApprovedQty6 = CASE ApprovedQty WHEN 6 THEN '*' ELSE NULL END,
	LaborGross = ISNULL(e.LaborGross, 0)
FROM	tEstimate e (nolock)
WHERE	e.EstimateKey = @EstimateKey

UPDATE
	#Expenses
SET
	LaborGrossSubtotal1 = e.BillableCost + e.LaborGross,
	LaborGrossSubtotal2 = e.BillableCost2 + e.LaborGross,
	LaborGrossSubtotal3 = e.BillableCost3 + e.LaborGross,
	LaborGrossSubtotal4 = e.BillableCost4 + e.LaborGross,
	LaborGrossSubtotal5 = e.BillableCost5 + e.LaborGross,
	LaborGrossSubtotal6 = e.BillableCost6 + e.LaborGross
FROM
	(
		SELECT
			MAX(LaborGross) AS LaborGross,
			SUM(ISNULL(BillableCost, 0)) AS BillableCost,
			SUM(ISNULL(BillableCost2, 0)) AS BillableCost2,
			SUM(ISNULL(BillableCost3, 0)) AS BillableCost3,
			SUM(ISNULL(BillableCost4, 0)) AS BillableCost4,
			SUM(ISNULL(BillableCost5, 0)) AS BillableCost5,
			SUM(ISNULL(BillableCost6, 0)) AS BillableCost6
		FROM #Expenses
	) e

SELECT	*
FROM	#Expenses
ORDER BY FinalOrder, DisplayOrder
GO
