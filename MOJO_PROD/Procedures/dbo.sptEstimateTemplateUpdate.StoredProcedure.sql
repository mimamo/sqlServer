USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTemplateUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTemplateUpdate]
	@EstimateTemplateKey int,
	@CompanyKey int,
	@TemplateName varchar(200),
	@EstDisplayMode smallint,
	@EstShowQuantity tinyint,
	@EstShowRate tinyint,
	@EstShowExpQuantity tinyint,
	@EstShowExpRate tinyint,
	@EstShowSubTasks smallint,
	@EstShowZeroAmounts tinyint,
	@EstShowZeroTaxes tinyint,
	@EstShowDetail tinyint,
	@EstShowQuantityText tinyint,
	@EstBreakoutExpenses tinyint,
	@FooterText text,
	@ContingencyText varchar(1000),
	@ShowProjectDescription tinyint,
	@GroupByBillingItem tinyint,
	@ShowAmountOnSummary tinyint,
	@RepeatHeader tinyint,
	@ShowApproverName tinyint,
	@LabelUserDefined1 varchar(100),
	@LabelUserDefined2 varchar(100),
	@LabelUserDefined3 varchar(100),
	@LabelUserDefined4 varchar(100),
	@LabelUserDefined5 varchar(100),
	@LabelUserDefined6 varchar(100),
	@LabelUserDefined7 varchar(100),
	@LabelUserDefined8 varchar(100),
	@LabelUserDefined9 varchar(100),
	@LabelUserDefined10 varchar(100),
	@HideCompanyName tinyint,
	@HideClientName tinyint,
	@ShowEstimateNumber tinyint,
	@EstShowProduct tinyint,
	@EstShowDivision tinyint,
	@KeepFooterTogether tinyint,
	@ShowLaborExpenseSubtotals tinyint,
	@HidePageNumbers tinyint,
	@CompareToOriginal tinyint
	

As --Encrypt

/*
|| When     Who Rel   What
|| 10/27/06 CRG 8.35  Added KeepFooterTogether parameter.
|| 04/26/07 GHL 8.5   Added ShowLaborExpenseSubtotals parameter.
|| 01/11/08 GHL 8.502 (19092) Added @HidePageNumbers
|| 02/25/08 GHL 8.505 (21518) Added @HideClientName
|| 01/02/15 GHL 10.587 (238741) Added CompareToOriginal for enh for Giant Strategy
*/

	UPDATE
		tEstimateTemplate
	SET
		CompanyKey = @CompanyKey,
		TemplateName = @TemplateName,
		EstDisplayMode = @EstDisplayMode,
		EstShowQuantity = @EstShowQuantity,
		EstShowRate = @EstShowRate,
		EstShowExpQuantity = @EstShowExpQuantity,
		EstShowExpRate = @EstShowExpRate,
		EstShowSubTasks = @EstShowSubTasks,
		EstShowZeroAmounts = @EstShowZeroAmounts,
		EstShowZeroTaxes = @EstShowZeroTaxes,
		EstShowDetail = @EstShowDetail,
		EstShowQuantityText = @EstShowQuantityText,
		EstBreakoutExpenses = @EstBreakoutExpenses,
		FooterText = @FooterText,
		ContingencyText = @ContingencyText,
		ShowProjectDescription = @ShowProjectDescription,
		GroupByBillingItem = @GroupByBillingItem, 
		ShowAmountOnSummary = @ShowAmountOnSummary,
		RepeatHeader = @RepeatHeader,
		ShowApproverName = @ShowApproverName,
		LabelUserDefined1 = @LabelUserDefined1,
		LabelUserDefined2 = @LabelUserDefined2,
		LabelUserDefined3 = @LabelUserDefined3,
		LabelUserDefined4 = @LabelUserDefined4,
		LabelUserDefined5 = @LabelUserDefined5,
		LabelUserDefined6 = @LabelUserDefined6,
		LabelUserDefined7 = @LabelUserDefined7,
		LabelUserDefined8 = @LabelUserDefined8,
		LabelUserDefined9 = @LabelUserDefined9,
		LabelUserDefined10 = @LabelUserDefined10,
		HideCompanyName = @HideCompanyName,
		HideClientName = @HideClientName,
		ShowEstimateNumber = @ShowEstimateNumber,
		EstShowProduct = @EstShowProduct,
		EstShowDivision = @EstShowDivision,
		KeepFooterTogether = @KeepFooterTogether,
		ShowLaborExpenseSubtotals = @ShowLaborExpenseSubtotals,
		HidePageNumbers = @HidePageNumbers,
		CompareToOriginal = @CompareToOriginal
	WHERE
		EstimateTemplateKey = @EstimateTemplateKey 

	RETURN 1
GO
