USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateNumberWJ]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateNumberWJ]
 @CompanyKey int,
 @ProjectNumStyle smallint,
 @ProjectNumPrefix varchar(10),
 @NextProjectNum int,
 @ProjectNumPlaces int,
 @ProjectNumSep char(1),
 @ProjectNumPrefixUseYear tinyint,
 @CampaignNumStyle smallint,
 @CampaignNumPrefix varchar(10),
 @NextCampaignNum int,
 @CampaignNumPlaces int,
 @CampaignNumSep char(1),
 @CampaignNumPrefixUseYear tinyint,
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
 @RequireProjectType tinyint,
 @NotifyExpenseReport int,
 @GetRateFrom smallint,
 @TimeRateSheetKey int,
 @TitleRateSheetKey int,
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
 @ShowServicesOnGrid tinyint,
 @ReqProjectOnTime tinyint,
 @ReqServiceOnTime tinyint,
 @EmailTimeSubmittal tinyint,
 @TimeSheetPeriod smallint,
 @StartTimeOn smallint,
 @AllowOverlap tinyint,
 @PrintAsGrid tinyint,
 @AllowCustomDates tinyint,
 @DefaultAutoIDTask tinyint,
 @DefaultSimpleSchedule tinyint,
 @UseClearedDate tinyint,
 @RequireCommentsOnTime tinyint,
 @UnverifiedTimeOption smallint,
 @UseToDo tinyint,
 @ActivityTypeOnToDo tinyint,
 @ActivityEmailSender tinyint,
 @UseSalesTaxOnExpenseReports tinyint,
 @TimerInterval tinyint,
 @TimerRounding tinyint,
 @CheckMethodKey int,
 @ClientReviewInstructions varchar(500),
 @ClientReviewEnableRouting tinyint,
 @ClientReviewAllApprove tinyint,
 @ClientReviewDaysToApprove int,
 @InternalReviewInstructions varchar(500),
 @InternalReviewEnableRouting tinyint,
 @InternalReviewAllApprove tinyint,
 @InternalReviewDaysToApprove int,
 @InternalReviewLoginRequired int,
 @InternalReviewSendReminder int,
 @InternalReviewPause int,
 @ClientReviewLoginRequired int,
 @ClientReviewSendReminder int,
 @ShowInactiveInCriteria tinyint,
 @EmployeePrimaryContact tinyint,
 @SendAllComments tinyint,
 @UseAdvProjectDiary tinyint,
 @POHeaderStandardTextKey int,
 @POFooterStandardTextKey int,
 @IOHeaderStandardTextKey int,
 @IOFooterStandardTextKey int,
 @BOHeaderStandardTextKey int,
 @BOFooterStandardTextKey int,
 @ShowActualHours tinyint,
 @UseAlternatePayer tinyint,
 @InternalReviewReminderType tinyint,
 @InternalReviewReminderInterval int,
 @ClientReviewReminderType tinyint,
 @ClientReviewReminderInterval int,
 @NoTimeBeforeGLCloseDate int,
 @DiaryFont varchar(100),
 @DiaryFontSize int,
 @EmailSubjectFormat int,
 @VendorInvoiceApproverNotification tinyint,
 @DFAUserID varchar(100),
 @DFAPassword varchar(100),
 @ClientInvoiceApproverNotification tinyint,
 @EmailFooter text,
 @OnlyOneApprovedEstimate tinyint,
 @CalendarNotificationsToStaffOnly tinyint,
 @RequireCampaignProjectClientMatch tinyint,
 @IOShowPremiumsAsSingleLine tinyint,
 @IOHideUserDefined1 tinyint,
 @IOHideUserDefined2 tinyint,
 @IOHideUserDefined3 tinyint,
 @IOHideUserDefined4 tinyint,
 @IOHideUserDefined5 tinyint,
 @IOHideUserDefined6 tinyint,
 @ShowReviewsTab tinyint,
 @UseBillingTitles tinyint,
 @RequireProducts tinyint,
 @RequireDivisions tinyint,
 @RequireUniqueIDOnProdDiv tinyint,
 @CloseMonthBLInvoice tinyint = null,
 @UseWWP tinyint,
 @RequireLoginForCC tinyint,
 @PostCCWhenSentToVendor tinyint,
 @AllowTransferDate tinyint,
 @DefaultDepartmentFromUser tinyint,
 @UpdateActualsOnBWS tinyint
AS --Encrypt

  /*
  || When     Who Rel		What 
  || 1/12/10  RLB 10516     Created for new Flex Transaction Preference page
  || 3/2/10   CRG 10.5.1.9  Added @DefaultAutoIDTask and @DefaultSimpleSchedule
  || 3/25/10  MAS 10.5.1.9  Added @UseClearedDate
  || 04/29/10 MAS 10.5.2.2  (78968)Added ReqCommentsOnTime
  || 08/31/10 RLB 10.5.3.4  (88154) Added @DefaultAPApprover 
  || 10/6/10  CRG 10.5.3.6  Added @UnverifiedTimeOption
  || 1/4/11   CRG 10.5.4.0  Added @UseToDo
  || 03/02/11 GHL 10.5.4.2  (103729) Added Campaign number fields
  || 04/13/11 RLB 10.5.4.3  (108715) Added option for Sales Tax on Expense Reports
  || 06/01/11 MAS 10.5.4.?  Added TimerInterval and TimerRounding options
  || 08/19/11 RLB 10.5.4.7  (108788) Added Default Check Method
  || 08/24/11 QMD 10.5.4.?  Add InternalReview... and ClientReview... fields
  || 11/18/11 RLB 10.5.5.0  (126142) Added Activty Types on To Do's
  || 01/03/12 MFT 10.5.5.1  (129121) Added ActivityEmailSender
  || 01/19/12 MAS 10.5.5.2  Added more InternalReview... and ClientReview... fields
  || 01/19/12 MFT 10.5.5.2  (124442) Added ShowInactiveInCriteria
  || 01/26/12 RLB 10.5.5.2  (123560) Added @EmployeePrimaryContact
  || 02/22/12 QMD 10.5.5.3  Added @SendAllComments
  || 03/06/12 GHL 10.5.5.4  Added @UseAdvProjectDiary (use old/advanced activities
  ||                        for the diary instead of the lab)
  || 04/25/12 RLB 10.5.5.5 (95991) Added for the enhancement
  || 06/15/12 RLB 10.5.5.7 Added Require Project Type
  || 06/18/12 RLB 10.5.5.7 Removed Require Time Details because it is getting moved to User level for HMI
  || 08/27/12 RLB 10.5.5.9 (152637) Adding option to Show Actual hours regardless of service
  || 09/10/12 MFT 10.5.5.9 Added UseAlternatePayer
  || 10/04/12 QMD 10.5.6.0 Add @InternalReviewReminderType, @InternalReviewReminderInterval, @ClientReviewReminderType,@ClientReviewReminderInterval
  || 10/30/12 WDF 10.5.6.1 (158213) Add @EmailTimeSubmittal flag for Timesheet Submittal email to Approver 
  || 11/06/12 RLB 10.5.6.2 (148135) Add option NoTimeBeforeGLCloseDate
  || 12/28/12 WDF 10.5.6.3 (162530) Added @CollapseSchedule for Projects in Transaction Preferences
  || 02/19/13 WDF 10.5.6.3 (167286) Added @DiaryFont and @DiaryFontSize
  || 02/28/13 MFT 10.5.6.3 (168934) Added @EmailSubjectFormat
  || 04/04/13 RLB 10.5.6.6 (172239) Added option to send approver notifications on vendor invoices
  || 04/15/13 CRG 10.5.6.7 Added DFAUserID and DFAPassword
  || 04/15/13 RLB 10.5.6.7 Added ClientInvoiceApproverNotification
  || 04/17/13 WDF 10.5.6.7 (168393) Added EmailFooter
  || 04/18/13 MAS 10.5.6.7 Removed EnableLogging
  || 05/15/13 MFT 10.5.6.8 Added @OnlyOneApprovedEstimate
  || 05/16/13 MFT 10.5.6.8 (178488) Added @CalendarNotificationsToStaffOnly
  || 07/22/13 WDF 10.5.7.0 (176825) Added @RequireCampaignProjectClientMatch
  || 09/18/13 MFT 10.5.7.2 Added IOShowPremiumsAsSingleLine, IOOneBuyPerPage & IOHideUserDefined1-6
  || 06/14/14 PLC 10.5.8.1  Added CloseMOnthBLINvoice for strata
  || 08/11/14 WDF 10.5.8.3 (223597) Remove @CollapseSchedule for Projects and put in tSession ('user' entity)
  || 09/15/14 MAS 10.5.8.3 Added @UseBillingTitles, @RequireProducts, @RequireDivisions, @RequireUniqueIDOnProdDiv for Abelson Taylor
  || 09/19/14 QMD 10.5.8.4 Added @UseWWP
  || 09/25/14 WDF 10.5.8.4 Added TitleRateSheetKey
  || 10/03/14 CRG 10.5.8.4 Added @RequireLoginForCC and @PostCCWhenSentToVendor
  || 10/28/14 GHL 10.5.8.5 Removed @IOOneBuyPerPage at SM's request because it is not used anymore
  || 11/07/14 GHL 10.5.8.6 Added @AllowTransferDate for AlbelsonTaylor
  ||                       If @AllowTransferDate = 1, we allow the choice of a transfer date
  ||                       If @AllowTransferDate = 0, the transfer date is the expense date 
  || 01/05/15 GHL 10.5.8.8 Added @DefaultDepartmentFromUser for AlbelsonTaylor
  ||                       If @DefaultDepartmentFromUser = 1, the dept comes from the user on client invoices and wip
  ||                       If @DefaultDepartmentFromUser = 0, the dept comes from the service on client invoices and wip
  || 01/22/15 GHL 10.5.8.8 Added @UpdateActualsOnBWS for Abelson Taylor. If this is set, the actual service and rate are 
  ||                       updated from a billing worksheet after editing a time entry
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
	CampaignNumStyle = @CampaignNumStyle,
	CampaignNumPrefix = @CampaignNumPrefix,
	NextCampaignNum = @NextCampaignNum,
	CampaignNumPlaces = @CampaignNumPlaces,
	CampaignNumSep = @CampaignNumSep,
	CampaignNumPrefixUseYear = @CampaignNumPrefixUseYear,
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
	RequireProjectType = @RequireProjectType,
	NotifyExpenseReport = @NotifyExpenseReport,
	GetRateFrom = @GetRateFrom,
	HourlyRate = 	@HourlyRate,
	GetMarkupFrom =	@GetMarkupFrom,
	TimeRateSheetKey = @TimeRateSheetKey,
	TitleRateSheetKey = @TitleRateSheetKey,
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
	DefaultAutoIDTask = @DefaultAutoIDTask,
	DefaultSimpleSchedule = @DefaultSimpleSchedule,
	UseClearedDate = @UseClearedDate,
	RequireCommentsOnTime = @RequireCommentsOnTime,
	UnverifiedTimeOption = @UnverifiedTimeOption,
	UseToDo = @UseToDo,
	ActivityTypeOnToDo = @ActivityTypeOnToDo,
	ActivityEmailSender = @ActivityEmailSender,
	UseSalesTaxOnExpenseReports = @UseSalesTaxOnExpenseReports,
	TimerInterval = @TimerInterval,
	TimerRounding = @TimerRounding,
	CheckMethodKey = @CheckMethodKey,
	InternalReviewInstructions = @InternalReviewInstructions,
	InternalReviewEnableRouting = @InternalReviewEnableRouting,
	InternalReviewAllApprove = @InternalReviewAllApprove,
	InternalReviewDaysToApprove = @InternalReviewDaysToApprove,
	ClientReviewInstructions = @ClientReviewInstructions,
	ClientReviewEnableRouting = @ClientReviewEnableRouting,
	ClientReviewAllApprove = @ClientReviewAllApprove,
	ClientReviewDaysToApprove = @ClientReviewDaysToApprove,
	InternalReviewLoginRequired = @InternalReviewLoginRequired,
	InternalReviewSendReminder = @InternalReviewSendReminder,
	InternalReviewPause = @InternalReviewPause,
	ClientReviewLoginRequired = @ClientReviewLoginRequired,
	ClientReviewSendReminder = @ClientReviewSendReminder,
	ShowInactiveInCriteria = @ShowInactiveInCriteria,
	EmployeePrimaryContact = @EmployeePrimaryContact,
	SendAllComments = @SendAllComments,
	UseAdvProjectDiary = @UseAdvProjectDiary,
	POHeaderStandardTextKey = @POHeaderStandardTextKey,
	POFooterStandardTextKey = @POFooterStandardTextKey,
	IOHeaderStandardTextKey = @IOHeaderStandardTextKey,
	IOFooterStandardTextKey = @IOFooterStandardTextKey,
	BOHeaderStandardTextKey = @BOHeaderStandardTextKey,
	BOFooterStandardTextKey = @BOFooterStandardTextKey,
	ShowActualHours = @ShowActualHours,
	UseAlternatePayer = @UseAlternatePayer,
	InternalReviewReminderType = @InternalReviewReminderType, 
	InternalReviewReminderInterval = @InternalReviewReminderInterval, 
	ClientReviewReminderType = @ClientReviewReminderType,
	ClientReviewReminderInterval = @ClientReviewReminderInterval,
	EmailTimeSubmittal = @EmailTimeSubmittal,
	NoTimeBeforeGLCloseDate = @NoTimeBeforeGLCloseDate,
	ShowReviewsTab = @ShowReviewsTab,
	DiaryFont = @DiaryFont,
	DiaryFontSize = @DiaryFontSize,
	EmailSubjectFormat = @EmailSubjectFormat,
	VendorInvoiceApproverNotification = @VendorInvoiceApproverNotification,
	DFAUserID = @DFAUserID,
	DFAPassword = @DFAPassword,
	ClientInvoiceApproverNotification = @ClientInvoiceApproverNotification,
	EmailFooter = @EmailFooter,
	OnlyOneApprovedEstimate = @OnlyOneApprovedEstimate,
	CalendarNotificationsToStaffOnly = @CalendarNotificationsToStaffOnly,
	RequireCampaignProjectClientMatch = @RequireCampaignProjectClientMatch,
	IOShowPremiumsAsSingleLine = @IOShowPremiumsAsSingleLine,
	IOHideUserDefined1 = @IOHideUserDefined1,
	IOHideUserDefined2 = @IOHideUserDefined2,
	IOHideUserDefined3 = @IOHideUserDefined3,
	IOHideUserDefined4 = @IOHideUserDefined4,
	IOHideUserDefined5 = @IOHideUserDefined5,
	IOHideUserDefined6 = @IOHideUserDefined6,
	CloseMonthBLInvoice = @CloseMonthBLInvoice,
	UseBillingTitles = @UseBillingTitles,
	RequireProducts = @RequireProducts,
	RequireDivisions = @RequireDivisions,
	RequireUniqueIDOnProdDiv = @RequireUniqueIDOnProdDiv,
	UseWWP = @UseWWP,
	RequireLoginForCC = @RequireLoginForCC,
	PostCCWhenSentToVendor = @PostCCWhenSentToVendor,
	AllowTransferDate = @AllowTransferDate,
	DefaultDepartmentFromUser = @DefaultDepartmentFromUser,
	UpdateActualsOnBWS = @UpdateActualsOnBWS
WHERE
	CompanyKey = @CompanyKey

UPDATE
  tTimeOption
SET
  ShowServicesOnGrid = @ShowServicesOnGrid,
  ReqProjectOnTime = @ReqProjectOnTime,
  ReqServiceOnTime = @ReqServiceOnTime,
  TimeSheetPeriod = @TimeSheetPeriod,
  StartTimeOn = @StartTimeOn,
  AllowOverlap = @AllowOverlap,
  PrintAsGrid = @PrintAsGrid,
  AllowCustomDates = @AllowCustomDates
WHERE
  CompanyKey = @CompanyKey 

RETURN 1
GO
