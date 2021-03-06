USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateNumber]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateNumber]
 @CompanyKey int,
 @ProjectNumStyle smallint,
 @ProjectNumPrefix varchar(10),
 @NextProjectNum int,
 @ProjectNumPlaces int,
 @ProjectNumSep char(1),
 @ProjectNumPrefixUseYear tinyint,
 @PONumPrefix varchar(10),
 @NextPONum int,
 @PONumPlaces int,
 @IONumPrefix varchar(10),
 @NextIONum int,
 @IONumPlaces int,
 @BCNumPrefix varchar(10),
 @NextBCNum int,
 @BCNumPlaces int,
 @ARNumPrefix varchar(10),
 @NextARNum int,
 @ARNumPlaces int,
 @DefaultARApprover smallint,
 @DefaultARApproverKey int,
 @DefaultAPApprover smallint,
 @DefaultAPApproverKey int, 
 @ExpenseNumPrefix varchar(10),
 @NextExpenseNum int,
 @ExpenseNumPlaces int,
 @RequireRequest tinyint,
 @NotifyExpenseReport int,
 @GetRateFrom smallint,
 @TimeRateSheetKey int,
 @HourlyRate money,
 @GetMarkupFrom money,
 @ItemRateSheetKey int,
 @ItemMarkup decimal(24,4),
 @IOCommission decimal(24,4),
 @BCCommission decimal(24,4),
 @GetItemRate tinyint,
 @DefaultPOType int,
 @DefaultPrintPOType int,
 @DefaultBCPOType int,
 @IOOrderDisplayMode smallint,
 @BCOrderDisplayMode smallint,
 @IOApprover int,
 @BCApprover int,
 @IOClientLink smallint,
 @BCClientLink smallint, 
 @PaymentTermsKey int,
 @SendAssignmentEmail tinyint,
 @AutoScheduleProjects tinyint,
 @RequireMasterTask tinyint,
 @DefaultARLineFormat smallint,
 @ShowCustomRptConditions tinyint,
 @SetInvoiceNumberOnApproval tinyint,
 @SyncDeletesContacts tinyint,
 @SyncDeleteEvents tinyint,
 @AutoApproveExternalOrders tinyint,
 @ActualDateUpdatesPlan tinyint,
 @RequireTimeDetails tinyint,
 @UseMilitaryTime tinyint,
 @IOPrintClientOnOrder tinyint,
 @BCPrintClientOnOrder tinyint,
 @EstimateNumStyle smallint,
 @EstimateNumPrefix varchar(10),
 @NextEstimateNum int,
 @EstimateNumPlaces int,
 @EstimateNumSep char(1),
 @EstimateNumPrefixUseYear tinyint,
 @EstimateInternalApprovalDays int,
 @EstimateExternalApprovalDays int,
 @IOAllowChangesAfterClientInvoice tinyint,
 @BCAllowChangesAfterClientInvoice tinyint,
 @IOShowAdjustmentsAsSingleLine tinyint,
 @BCShowAdjustmentsAsSingleLine tinyint,
 @IOUseClientCosting tinyint,
 @BCUseClientCosting tinyint,
 @BCUseProductName tinyint,
 @EditVendorInvTax tinyint,
 @POUnitCostDecimalPlaces int,
 @POQtyDecimalPlaces int,
 @UseUnitRate tinyint,
 @AutoApproveExternalInvoices tinyint,
 @UseClearedDate tinyint,
 @BCGeneratePrebilledRevisions tinyint,
 @IOGeneratePrebilledRevisions tinyint,
 @PrintTrafficOnBC tinyint,
 @UseExpenseTypeClassOnVoucher tinyint,
 @AutoGenVoucherFromER tinyint,
 @SplitBilling tinyint,
 @DuplicateVendorInvoiceNbr tinyint,
 @UseCompanyFolders tinyint,
 @UseContactFolders tinyint,
 @UseLeadFolders tinyint,
 @UseActivityFolders tinyint,
 @UseOppFolders tinyint,
 @EmailsVisibleToClient tinyint,
 @EmailsDefaultActivityTypeKey int,
 @DefaultActivityTypeKey int,
 @AutoGenerateInvoiceOrderLines tinyint,
 @RequireCommentsOnTime tinyint = null,
 @CloseMonthBLInvoice tinyint = null
 
AS --Encrypt

  /*
  || When     Who Rel		What
  || 01/11/07 GHL 8.4		Added RequireMasterTask logic to limit problems with missing tTask.MasterTaskKey 
  || 05/07/07 CRG 8.4.3		(9061) Added UseExpenseTypeClassOnVoucher parameter
  || 09/05/07 GWG 8.5		Added the autogen parameter
  || 10/22/07 CRG 8.5		(13583) Added SplitBilling parameter
  || 06/03/08 RTC 8.5		Added DuplicateVendorInvoiceNbr
  || 04/03/09 GWG 10.5		Added Email codes
  || 05/29/09 RTC 10.5		Added AutoGenerateInvoiceOrderLines
  || 06/10/09 QMD 10.5		Added SyncDeleteEvent
  || 11/12/09 MAS 10.5.1.3  (68340)Added ClientCosting 
  || 11/12/09 MAS 10.5.1.7  (72080)Added BCUseProductName 
  || 03/26/10 MAS 10.5.2	(76058)Added UseClearedDate
  || 04/29/10 MAS 10.5.2.2  (78968)Added ReqCommentsOnTime
  || 08/31/10 RLB 10.5.3.4  (88154) Added @DefaultAPApprover 
  || 04/18/13 MAS 10.5.6.7  Removed EnableLogging
  || 06/14/14 PLC 10.5.8.1  Added CloseMOnthBLINvoice for strata
  */
  
 DECLARE @OldRequireMasterTask INT
 SELECT  @OldRequireMasterTask = RequireMasterTask FROM tPreference (NOLOCK) WHERE CompanyKey = @CompanyKey
 IF @OldRequireMasterTask = 0 AND @RequireMasterTask = 1
 BEGIN
	UPDATE tTask
	SET    tTask.MasterTaskKey = mt.MasterTaskKey
	FROM   tProject p (NOLOCK)
	      ,tMasterTask mt (NOLOCK)
	WHERE  p.ProjectKey = tTask.ProjectKey
	AND    p.CompanyKey = @CompanyKey
	AND    mt.CompanyKey = @CompanyKey
	AND    tTask.TrackBudget = 1
	AND    tTask.MasterTaskKey IS NULL
	AND    tTask.TaskID = mt.TaskID
 END
 
 UPDATE
  tPreference
 SET
  ProjectNumStyle = @ProjectNumStyle,
  ProjectNumPrefix = @ProjectNumPrefix,
  NextProjectNum = @NextProjectNum,
  ProjectNumPlaces = @ProjectNumPlaces,
  ProjectNumSep = @ProjectNumSep,
  ProjectNumPrefixUseYear = @ProjectNumPrefixUseYear,
  PONumPrefix = @PONumPrefix,
  NextPONum = @NextPONum,
  PONumPlaces = @PONumPlaces,
  IONumPrefix = @IONumPrefix,
  NextIONum = @NextIONum,
  IONumPlaces = @IONumPlaces,
  BCNumPrefix = @BCNumPrefix,
  NextBCNum = @NextBCNum,
  BCNumPlaces = @BCNumPlaces,
  ARNumPrefix = @ARNumPrefix,
  NextARNum = @NextARNum,
  ARNumPlaces = @ARNumPlaces,
  DefaultARApprover = @DefaultARApprover,
  DefaultARApproverKey = @DefaultARApproverKey,
  DefaultAPApprover = @DefaultAPApprover,
  DefaultAPApproverKey = @DefaultAPApproverKey,
  ExpenseNumPrefix = @ExpenseNumPrefix,
  NextExpenseNum = @NextExpenseNum,
  ExpenseNumPlaces = @ExpenseNumPlaces,
  RequireRequest = @RequireRequest,
  NotifyExpenseReport = @NotifyExpenseReport,
  GetRateFrom = @GetRateFrom,
  HourlyRate = 	@HourlyRate,
  GetMarkupFrom =	@GetMarkupFrom,
  TimeRateSheetKey = @TimeRateSheetKey,
  ItemRateSheetKey = 	@ItemRateSheetKey,
  ItemMarkup =	@ItemMarkup,
  IOCommission = @IOCommission,
  BCCommission = @BCCommission,
  GetItemRate = @GetItemRate,
  DefaultPOType = @DefaultPOType,
  DefaultPrintPOType = @DefaultPrintPOType,
  DefaultBCPOType = @DefaultBCPOType,
  IOOrderDisplayMode = @IOOrderDisplayMode,
  BCOrderDisplayMode = @BCOrderDisplayMode,
  IOApprover = @IOApprover,
  BCApprover = @BCApprover,
  IOClientLink = @IOClientLink,
  BCClientLink = @BCClientLink,
  PaymentTermsKey = @PaymentTermsKey,
  SendAssignmentEmail = @SendAssignmentEmail,
  AutoScheduleProjects = @AutoScheduleProjects,
  RequireMasterTask = @RequireMasterTask,
  DefaultARLineFormat = @DefaultARLineFormat,
  ShowCustomRptConditions = @ShowCustomRptConditions,
  SetInvoiceNumberOnApproval = @SetInvoiceNumberOnApproval,
  SyncDeletesContacts = @SyncDeletesContacts,
  SyncDeleteEvents = @SyncDeleteEvents,
  AutoApproveExternalOrders = @AutoApproveExternalOrders,
  ActualDateUpdatesPlan = @ActualDateUpdatesPlan,
  RequireTimeDetails = @RequireTimeDetails,	
  UseMilitaryTime = @UseMilitaryTime,
  IOPrintClientOnOrder = @IOPrintClientOnOrder,
  BCPrintClientOnOrder = @BCPrintClientOnOrder,
  EstimateNumStyle = @EstimateNumStyle,
  EstimateNumPrefix = @EstimateNumPrefix,
  NextEstimateNum = @NextEstimateNum,
  EstimateNumPlaces = @EstimateNumPlaces,
  EstimateNumSep = @EstimateNumSep,
  EstimateNumPrefixUseYear = @EstimateNumPrefixUseYear,  
  EstimateInternalApprovalDays = @EstimateInternalApprovalDays,  
  EstimateExternalApprovalDays = @EstimateExternalApprovalDays,  
  IOAllowChangesAfterClientInvoice = @IOAllowChangesAfterClientInvoice, 
  BCAllowChangesAfterClientInvoice = @BCAllowChangesAfterClientInvoice, 
  IOShowAdjustmentsAsSingleLine = @IOShowAdjustmentsAsSingleLine,
  BCShowAdjustmentsAsSingleLine = @BCShowAdjustmentsAsSingleLine,
  IOUseClientCosting = @IOUseClientCosting,
  BCUseClientCosting = @BCUseClientCosting,
  BCUseProductName = @BCUseProductName,
  EditVendorInvTax = @EditVendorInvTax,
  POUnitCostDecimalPlaces = @POUnitCostDecimalPlaces,
  POQtyDecimalPlaces = @POQtyDecimalPlaces,
  UseUnitRate = @UseUnitRate,
  AutoApproveExternalInvoices = @AutoApproveExternalInvoices,
  UseClearedDate = @UseClearedDate,
  BCGeneratePrebilledRevisions = @BCGeneratePrebilledRevisions,
  IOGeneratePrebilledRevisions = @IOGeneratePrebilledRevisions,
  PrintTrafficOnBC = @PrintTrafficOnBC,
  UseExpenseTypeClassOnVoucher = @UseExpenseTypeClassOnVoucher,
  AutoGenVoucherFromER = @AutoGenVoucherFromER,
  SplitBilling = @SplitBilling,
  DuplicateVendorInvoiceNbr = @DuplicateVendorInvoiceNbr,
  UseCompanyFolders = @UseCompanyFolders,
  UseContactFolders = @UseContactFolders,
  UseLeadFolders = @UseLeadFolders,
  UseActivityFolders = @UseActivityFolders,
  UseOppFolders = @UseOppFolders,
  EmailsVisibleToClient = @EmailsVisibleToClient,
  EmailsDefaultActivityTypeKey = @EmailsDefaultActivityTypeKey,
  DefaultActivityTypeKey = @DefaultActivityTypeKey,
  AutoGenerateInvoiceOrderLines = @AutoGenerateInvoiceOrderLines,
  RequireCommentsOnTime = @RequireCommentsOnTime,
  CloseMonthBLInvoice = isnull(CloseMonthBLInvoice,0)
 WHERE
  CompanyKey = @CompanyKey 
 RETURN 1
GO
