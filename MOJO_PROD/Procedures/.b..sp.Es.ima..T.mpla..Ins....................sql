USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTemplateInsert]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTemplateInsert]
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
	@ShowProjectDescription tinyint,
	@GroupByBillingItem tinyint,
	@ShowAmountOnSummary tinyint,
	@ContingencyText varchar(1000),
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
	@CompareToOriginal tinyint = 0,
	@oIdentity INT OUTPUT
As --Encrypt

/*
|| When     Who Rel   What
|| 10/27/06 CRG 8.35  Added KeepFooterTogether parameter.
|| 04/26/07 GHL 8.5   Added ShowLaborExpenseSubtotals parameter.
|| 01/11/08 GHL 8.502 (19092) Added @HidePageNumbers
|| 02/25/08 GHL 8.505 (21518) Added @HideClientName
|| 01/02/15 GHL 10.587 (238741) Added CompareToOriginal for enh for Giant Strategy
|| 02/19/15 KMC 10.589 (246947) Added default value to @CompareToOriginal
*/

	INSERT tEstimateTemplate
		(
		CompanyKey,
		TemplateName,
		EstDisplayMode,
		EstShowQuantity,
		EstShowRate,
		EstShowExpQuantity,
		EstShowExpRate,
		EstShowSubTasks,
		EstShowZeroAmounts,
		EstShowZeroTaxes,
		EstShowDetail,
		EstShowQuantityText,
		EstBreakoutExpenses,
		ShowProjectDescription,
		ShowAmountOnSummary,
		GroupByBillingItem,
		FooterText,
		ContingencyText,
		RepeatHeader,
		ShowApproverName,
		LogoTop,
		LogoLeft,
		LogoHeight,
		LogoWidth,
		CompanyAddressTop,
		CompanyAddressLeft,
		CompanyAddressWidth,
		ClientAddressTop,
		ClientAddressLeft,
		ClientAddressWidth,
		Address1,
		Address2,
		Address3,
		Address4,
		Address5,
		CustomLogo,
		LabelTop,
		LabelLeft,
		LabelWidth,
		LabelSize,
		LabelFontName,
		LabelText,
		SSubjectFont,
		SSubjectSize,
		SSubjectBold,
		SSubjectItalic,
		SDescFont,
		SDescSize,
		SDescBold,
		SDescItalic,
		TSubjectFont,
		TSubjectSize,
		TSubjectBold,
		TSubjectItalic,
		TDescFont,
		TDescSize,
		TDescBold,
		TDescItalic,
		DHeaderFont,
		DHeaderSize,
		DHeaderBold,
		DHeaderItalic,
		DHeaderBorderStyle,
		DDetailFont,
		DDetailSize,
		DDetailBold,
		DDetailItalic,
		AddressFont,
		AddressSize,
		AddressBold,
		AddressItalic,
		HeaderFont,
		HeaderSize,
		HeaderBold,
		HeaderItalic,
		FooterFont,
		FooterSize,
		FooterBold,
		FooterItalic,
		LabelUserDefined1,
		LabelUserDefined2,
		LabelUserDefined3,
		LabelUserDefined4,
		LabelUserDefined5,
		LabelUserDefined6,
		LabelUserDefined7,
		LabelUserDefined8,
		LabelUserDefined9,
		LabelUserDefined10,
		HideCompanyName,
		HideClientName,
		ShowEstimateNumber,
		EstShowProduct,
		EstShowDivision,
		KeepFooterTogether,
		ShowLaborExpenseSubtotals,
		HidePageNumbers,
		CompareToOriginal
		)

	VALUES
		(
		@CompanyKey,
		@TemplateName,
		@EstDisplayMode,
		@EstShowQuantity,
		@EstShowRate,
		@EstShowExpQuantity,
		@EstShowExpRate,
		@EstShowSubTasks,
		@EstShowZeroAmounts,
		@EstShowZeroTaxes,
		@EstShowDetail,
		@EstShowQuantityText,
		@EstBreakoutExpenses,
		@ShowProjectDescription,
		@ShowAmountOnSummary,
		@GroupByBillingItem,
		@FooterText,
		@ContingencyText,
		@RepeatHeader,
		@ShowApproverName,
		0,
		0,
		1,
		3,
		.5,
		5,
		2.5,
		1.5,
		0,
		3,
		'',
		'',
		'',
		'',
		'',
		0,
		0,
		5,
		2.5,
		12,
		'Arial',
		'Estimate',
		'Arial',
		9,
		1,
		0,
		'Arial',
		9,
		0,
		1,
		'Arial',
		7,
		0,
		0,
		'Arial',
		7,
		0,
		1,
		'Arial',
		7,
		1,
		0,
		2,
		'Arial',
		7,
		0,
		0,
		'Arial',
		7,
		1,
		0,
		'Arial',
		7,
		0,
		0,
		'Arial',
		7,
		0,
		0,
		@LabelUserDefined1,
		@LabelUserDefined2,
		@LabelUserDefined3,
		@LabelUserDefined4,
		@LabelUserDefined5,
		@LabelUserDefined6,
		@LabelUserDefined7,
		@LabelUserDefined8,
		@LabelUserDefined9,
		@LabelUserDefined10,
		@HideCompanyName,
		@HideClientName,
		@ShowEstimateNumber,
		@EstShowProduct,
		@EstShowDivision,
		@KeepFooterTogether,
		@ShowLaborExpenseSubtotals,
		@HidePageNumbers,
		@CompareToOriginal
		)

	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
