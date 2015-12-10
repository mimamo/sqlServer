USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceTemplateUpdate]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptInvoiceTemplateUpdate]
	@InvoiceTemplateKey int,
	@CompanyKey int,
	@TemplateName varchar(200),
	@ShowAmountsAtSummary tinyint,
	@ShowDetailLines tinyint,
	@ShowTime tinyint,
	@TimeSummaryLevel smallint,
	@ShowComments tinyint,
	@ShowExpenses tinyint,
	@ShowProjectCustFields tinyint,
	@ShowProjectNumber tinyint,
	@ShowClientProjectNumber tinyint,
	@ShowProjectDescription tinyint,
	@QtyDescription tinyint,
	@ClientProjectNumberLabel varchar(100),
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
	@FooterMessage varchar(2000),
	@ShowAE tinyint,
	@ShowClientUserDefined tinyint,
	@RepeatHeader tinyint,
	@HidePageNumbers tinyint,
	@HideZeroReceipts tinyint,
	@ShowLaborHrs tinyint,
	@ShowLaborRate tinyint,
	@ShowTitle tinyint,
	@GroupLaborDetailBy smallint,
	@ShowExpDate tinyint,
	@ShowExpDescription tinyint,
	@ShowExpComments tinyint,
	@ShowExpItemDesc tinyint,
	@ShowExpQty tinyint,
	@ShowExpRate tinyint,
	@ShowExpNet tinyint,
	@ShowExpMarkup tinyint,
	@ShowExpGross tinyint,
	@SortExpBy smallint,
	@GroupExpByItem tinyint,
	@ShowZeroTaxes tinyint,
	@ShowLineQuantityRate tinyint,
	@HideCompanyName tinyint,
	@HideClientName tinyint,
	@ShowProduct tinyint,
	@ShowDivision tinyint,
	@ShowBillingSummary tinyint,
	@ShowCampaign tinyint

AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/05/06 GHL 8.4   Added Show Billing Summary flag 
  || 02/25/08 GHL 8.505 (21518) Added @HideClientName
  || 09/22/09 GHL 10.511 (63345) Added ShowExpComments
  || 09/10/12 RLB 10.560 (153617) Added ShowCampaign
  */
  
	UPDATE
		tInvoiceTemplate
	SET
		CompanyKey = @CompanyKey,
		TemplateName = @TemplateName,
		ShowAmountsAtSummary = @ShowAmountsAtSummary,
		ShowDetailLines = @ShowDetailLines,
		ShowTime = @ShowTime,
		TimeSummaryLevel = @TimeSummaryLevel,
		ShowComments = @ShowComments,
		ShowExpenses = @ShowExpenses,
		ShowProjectCustFields = @ShowProjectCustFields,
		ShowProjectNumber = @ShowProjectNumber,
		ShowClientProjectNumber = @ShowClientProjectNumber,
		ShowProjectDescription = @ShowProjectDescription,
		QtyDescription = @QtyDescription,
		ClientProjectNumberLabel = @ClientProjectNumberLabel,
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
		FooterMessage = @FooterMessage,
		ShowAE = @ShowAE,
		ShowClientUserDefined = @ShowClientUserDefined,
		RepeatHeader = @RepeatHeader,
		HidePageNumbers = @HidePageNumbers,
		HideZeroReceipts = @HideZeroReceipts,
		ShowLaborHrs = @ShowLaborHrs,
		ShowLaborRate = @ShowLaborRate,
		ShowTitle = @ShowTitle,
		GroupLaborDetailBy = @GroupLaborDetailBy,
		ShowExpDate = @ShowExpDate,
		ShowExpDescription = @ShowExpDescription,
	    ShowExpComments = @ShowExpComments,
		ShowExpItemDesc = @ShowExpItemDesc,
		ShowExpQty = @ShowExpQty,
		ShowExpRate = @ShowExpRate,
		ShowExpNet = @ShowExpNet,
		ShowExpMarkup = @ShowExpMarkup,
		ShowExpGross = @ShowExpGross,
		SortExpBy = @SortExpBy,
		GroupExpByItem = @GroupExpByItem,
		ShowZeroTaxes = @ShowZeroTaxes,
		ShowLineQuantityRate = @ShowLineQuantityRate,
		HideCompanyName = @HideCompanyName,
		HideClientName = @HideClientName,
		ShowProduct = @ShowProduct,
		ShowDivision = @ShowDivision,
		ShowBillingSummary = @ShowBillingSummary,
		ShowCampaign = @ShowCampaign
	WHERE
		InvoiceTemplateKey = @InvoiceTemplateKey 

	RETURN 1
GO
