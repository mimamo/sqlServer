USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tPreference]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tPreference](
	[CompanyKey] [int] NOT NULL,
	[StyleSheetKey] [int] NULL,
	[AffiliateKey] [int] NULL,
	[SmallLogo] [varchar](255) NULL,
	[LargeLogo] [varchar](255) NULL,
	[ReportLogo] [varchar](255) NULL,
	[DateJoined] [smalldatetime] NULL,
	[AutoScheduleProjects] [tinyint] NULL,
	[ProjectNumStyle] [smallint] NULL,
	[ProjectNumPrefix] [varchar](10) NULL,
	[NextProjectNum] [int] NULL,
	[ProjectNumPlaces] [int] NULL,
	[ProjectNumSep] [char](1) NULL,
	[ProjectNumPrefixUseYear] [tinyint] NULL,
	[PONumPrefix] [varchar](10) NULL,
	[NextPONum] [int] NULL,
	[PONumPlaces] [int] NULL,
	[IONumPrefix] [varchar](10) NULL,
	[NextIONum] [int] NULL,
	[IONumPlaces] [int] NULL,
	[BCNumPrefix] [varchar](10) NULL,
	[NextBCNum] [int] NULL,
	[BCNumPlaces] [int] NULL,
	[DefaultARAccountKey] [int] NULL,
	[DefaultSalesAccountKey] [int] NULL,
	[DefaultAPAccountKey] [int] NULL,
	[DefaultExpenseAccountKey] [int] NULL,
	[DefaultCashAccountKey] [int] NULL,
	[WriteOffAccountKey] [int] NULL,
	[AdvBillAccountKey] [int] NULL,
	[UnappliedCashAccountKey] [int] NULL,
	[UnappliedPaymentAccountKey] [int] NULL,
	[DiscountAccountKey] [int] NULL,
	[WIPLaborAssetAccountKey] [int] NULL,
	[WIPLaborIncomeAccountKey] [int] NULL,
	[WIPLaborWOAccountKey] [int] NULL,
	[WIPExpenseAssetAccountKey] [int] NULL,
	[WIPExpenseIncomeAccountKey] [int] NULL,
	[WIPExpenseWOAccountKey] [int] NULL,
	[WIPMediaAssetAccountKey] [int] NULL,
	[WIPMediaWOAccountKey] [int] NULL,
	[WIPPrintItemKey] [int] NULL,
	[WIPBCItemKey] [int] NULL,
	[WIPClassFromDetail] [tinyint] NULL,
	[ARNumPrefix] [varchar](50) NULL,
	[NextARNum] [int] NULL,
	[ARNumPlaces] [int] NULL,
	[DefaultARApprover] [smallint] NULL,
	[ExpenseNumPrefix] [varchar](50) NULL,
	[NextExpenseNum] [int] NULL,
	[ExpenseNumPlaces] [int] NULL,
	[AdvBillItemKey] [int] NULL,
	[RequireGLAccounts] [tinyint] NULL,
	[PostToGL] [tinyint] NULL,
	[TrackWIP] [tinyint] NULL,
	[RequireItems] [tinyint] NULL,
	[GLClosedDate] [smalldatetime] NULL,
	[FirstMonth] [int] NOT NULL,
	[NextJournalNumber] [int] NULL,
	[PostSalesUsingDetail] [tinyint] NULL,
	[TrackOverUnder] [tinyint] NULL,
	[LaborOverUnderAccountKey] [int] NULL,
	[ExpenseOverUnderAccountKey] [int] NULL,
	[ProductVersion] [varchar](50) NULL,
	[RequireRequest] [tinyint] NULL,
	[TrackQuantityOnHand] [tinyint] NULL,
	[ShowLogo] [tinyint] NULL,
	[NotifyExpenseReport] [int] NULL,
	[DefaultBCPOType] [int] NULL,
	[DefaultPrintPOType] [int] NULL,
	[GetRateFrom] [smallint] NULL,
	[TimeRateSheetKey] [int] NULL,
	[HourlyRate] [money] NULL,
	[GetMarkupFrom] [smallint] NULL,
	[ItemRateSheetKey] [int] NULL,
	[ItemMarkup] [decimal](24, 4) NULL,
	[AutoApproveExternalOrders] [tinyint] NULL,
	[IOCommission] [decimal](24, 4) NULL,
	[BCCommission] [decimal](24, 4) NULL,
	[GetItemRate] [tinyint] NULL,
	[IOClientLink] [smallint] NULL,
	[BCClientLink] [smallint] NULL,
	[POAccruedExpenseAccountKey] [int] NULL,
	[POPrebillAccrualAccountKey] [int] NULL,
	[IOOrderDisplayMode] [smallint] NULL,
	[BCOrderDisplayMode] [smallint] NULL,
	[IOApprover] [int] NULL,
	[BCApprover] [int] NULL,
	[PaymentTermsKey] [int] NULL,
	[SendAssignmentEmail] [tinyint] NULL,
	[RequireTasks] [tinyint] NULL,
	[RequireClasses] [tinyint] NULL,
	[RequireMasterTask] [tinyint] NULL,
	[PwdRequireNumbers] [tinyint] NULL,
	[PwdRequireLetters] [tinyint] NULL,
	[PwdMinLength] [int] NULL,
	[PwdRememberLast] [int] NULL,
	[PwdBadLoginLockout] [int] NULL,
	[PwdDaysBetweenChanges] [int] NULL,
	[TrackRevisions] [tinyint] NULL,
	[RevisionsToKeep] [int] NULL,
	[DefaultClassKey] [int] NULL,
	[FixedFeeBillingClassDetail] [tinyint] NULL,
	[EnableLogging] [tinyint] NULL,
	[DefaultARLineFormat] [smallint] NULL,
	[ShowCustomRptConditions] [tinyint] NULL,
	[PopServer] [varchar](250) NULL,
	[PopUserID] [varchar](250) NULL,
	[PopPassword] [varchar](250) NULL,
	[EmailsVisibleToClient] [tinyint] NULL,
	[SetInvoiceNumberOnApproval] [tinyint] NULL,
	[MissingTime] [smalldatetime] NULL,
	[MissingTimeSheet] [smalldatetime] NULL,
	[MissingTimeSheetFreq] [smallint] NULL,
	[BudgetUpdate] [smalldatetime] NULL,
	[CCProcessor] [int] NULL,
	[CCLoginID] [varchar](100) NULL,
	[CCPassword] [varchar](100) NULL,
	[CCAltURL] [varchar](500) NULL,
	[ANTranKey] [varchar](100) NULL,
	[ANHashSecret] [varchar](100) NULL,
	[SyncDeletesContacts] [tinyint] NULL,
	[ActualDateUpdatesPlan] [tinyint] NULL,
	[DefaultExpenseAccountFromItem] [tinyint] NULL,
	[DefaultARApproverKey] [int] NULL,
	[DefaultAPApproverKey] [int] NULL,
	[RequireTimeDetails] [tinyint] NULL,
	[UseMilitaryTime] [tinyint] NULL,
	[EstimateNumStyle] [smallint] NULL,
	[EstimateNumPrefix] [varchar](10) NULL,
	[NextEstimateNum] [int] NULL,
	[EstimateNumPlaces] [int] NULL,
	[EstimateNumSep] [char](1) NULL,
	[EstimateNumPrefixUseYear] [tinyint] NULL,
	[IOPrintClientOnOrder] [tinyint] NULL,
	[BCPrintClientOnOrder] [tinyint] NULL,
	[MissingApproval] [smalldatetime] NULL,
	[EstimateInternalApprovalDays] [int] NULL,
	[EstimateExternalApprovalDays] [int] NULL,
	[Customizations] [varchar](1000) NULL,
	[POAllowChangesAfterClientInvoice] [tinyint] NULL,
	[IOAllowChangesAfterClientInvoice] [tinyint] NULL,
	[BCAllowChangesAfterClientInvoice] [tinyint] NULL,
	[BCShowAdjustmentsAsSingleLine] [tinyint] NULL,
	[IOShowAdjustmentsAsSingleLine] [tinyint] NULL,
	[EditVendorInvTax] [tinyint] NULL,
	[POUnitCostDecimalPlaces] [int] NULL,
	[UseUnitRate] [tinyint] NULL,
	[AutoApproveExternalInvoices] [tinyint] NULL,
	[BCGeneratePrebilledRevisions] [tinyint] NULL,
	[IOGeneratePrebilledRevisions] [tinyint] NULL,
	[PrintTrafficOnBC] [tinyint] NULL,
	[POQtyDecimalPlaces] [int] NULL,
	[SystemEmail] [varchar](300) NULL,
	[ForceSystemAsFrom] [tinyint] NULL,
	[WIPRecognizeCostRev] [tinyint] NULL,
	[UseExpenseTypeClassOnVoucher] [tinyint] NULL,
	[UseGLCompany] [tinyint] NULL,
	[UseOffice] [tinyint] NULL,
	[UseDepartment] [tinyint] NULL,
	[UseClass] [tinyint] NULL,
	[ReportFont] [varchar](100) NULL,
	[RequireGLCompany] [tinyint] NULL,
	[RequireOffice] [tinyint] NULL,
	[RequireDepartment] [tinyint] NULL,
	[UseTasks] [tinyint] NULL,
	[UseItems] [tinyint] NULL,
	[AccrueCostToItemExpenseAccount] [tinyint] NULL,
	[WIPVoucherAssetAccountKey] [int] NULL,
	[WIPVoucherWOAccountKey] [int] NULL,
	[AutoGenVoucherFromER] [tinyint] NULL,
	[DefaultPOType] [int] NULL,
	[SplitBilling] [tinyint] NULL,
	[DesktopColor1] [int] NULL,
	[DesktopColor2] [int] NULL,
	[DesktopImage] [varchar](300) NULL,
	[DesktopImageSetting] [varchar](30) NULL,
	[DesktopImageIndex] [int] NULL,
	[DesktopImageScale] [tinyint] NULL,
	[DesktopWindowColor] [int] NULL,
	[DesktopLogoPosition] [int] NULL,
	[ReportTitleFontSize] [int] NULL,
	[ReportConditionsFontSize] [int] NULL,
	[ReportTopLabelsFontSize] [int] NULL,
	[ReportGroupFontSize] [int] NULL,
	[ReportDetailFontSize] [int] NULL,
	[ReportSubTotalFontSize] [int] NULL,
	[ReportGrandTotalFontSize] [int] NULL,
	[ReportPageFooterFontSize] [int] NULL,
	[EnableSystemInfo] [tinyint] NULL,
	[UseCustomStyle] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[DuplicateVendorInvoiceNbr] [tinyint] NULL,
	[PopUseSSL] [tinyint] NULL,
	[PopPort] [int] NULL,
	[SyncDeleteEvents] [tinyint] NULL,
	[UseCompanyFolders] [tinyint] NULL,
	[UseContactFolders] [tinyint] NULL,
	[UseLeadFolders] [tinyint] NULL,
	[UseActivityFolders] [tinyint] NULL,
	[UseOppFolders] [tinyint] NULL,
	[EmailsDefaultActivityTypeKey] [int] NULL,
	[DefaultActivityTypeKey] [int] NULL,
	[AutoGenerateInvoiceOrderLines] [tinyint] NULL,
	[IOUseClientCosting] [tinyint] NULL,
	[BCUseClientCosting] [tinyint] NULL,
	[UseAdvProjectLayouts] [tinyint] NULL,
	[DefaultLayoutKey] [tinyint] NULL,
	[BCUseProductName] [tinyint] NULL,
	[DefaultAutoIDTask] [tinyint] NULL,
	[DefaultSimpleSchedule] [tinyint] NULL,
	[UseClearedDate] [int] NULL,
	[RequireCommentsOnTime] [tinyint] NULL,
	[DefaultAPApprover] [smallint] NULL,
	[UnverifiedTimeOption] [smallint] NULL,
	[WIPBookVoucherToRevenue] [tinyint] NULL,
	[WIPMediaIncomeAccountKey] [int] NULL,
	[WIPVoucherIncomeAccountKey] [int] NULL,
	[WIPExpensesAtGross] [tinyint] NULL,
	[UseToDo] [tinyint] NULL,
	[PopEmail] [varchar](250) NULL,
	[CampaignNumStyle] [smallint] NULL,
	[CampaignNumPrefix] [varchar](10) NULL,
	[NextCampaignNum] [int] NULL,
	[CampaignNumPlaces] [int] NULL,
	[CampaignNumSep] [char](1) NULL,
	[CampaignNumPrefixUseYear] [tinyint] NULL,
	[AdvBillAccountOnly] [tinyint] NULL,
	[TaskReminder] [smalldatetime] NULL,
	[TimerInterval] [int] NULL,
	[TimerRounding] [int] NULL,
	[UseSalesTaxOnExpenseReports] [tinyint] NULL,
	[DefaultGLCompanyKey] [int] NULL,
	[CheckMethodKey] [int] NULL,
	[WebDavServerKey] [int] NULL,
	[InternalReviewInstructions] [varchar](500) NULL,
	[InternalReviewEnableRouting] [tinyint] NULL,
	[InternalReviewAllApprove] [tinyint] NULL,
	[InternalReviewDaysToApprove] [int] NULL,
	[ClientReviewInstructions] [varchar](500) NULL,
	[ClientReviewEnableRouting] [tinyint] NULL,
	[ClientReviewAllApprove] [tinyint] NULL,
	[ClientReviewDaysToApprove] [int] NULL,
	[UsingWebDav] [tinyint] NULL,
	[DisableValidation] [tinyint] NULL,
	[ActivityTypeOnToDo] [tinyint] NULL,
	[CCPartnerID] [varchar](100) NULL,
	[ActivityEmailSender] [tinyint] NULL,
	[ArtReviewReminder] [smalldatetime] NULL,
	[WebDavLinkTimeStamp] [smallint] NULL,
	[WebDavAlternatePath] [varchar](300) NULL,
	[InternalReviewLoginRequired] [int] NULL,
	[InternalReviewSendReminder] [int] NULL,
	[InternalReviewPause] [int] NULL,
	[ClientReviewLoginRequired] [int] NULL,
	[ClientReviewSendReminder] [int] NULL,
	[ShowInactiveInCriteria] [tinyint] NULL,
	[EmployeePrimaryContact] [tinyint] NULL,
	[SendAllComments] [tinyint] NULL,
	[UseAdvProjectDiary] [tinyint] NULL,
	[RestrictToGLCompany] [tinyint] NULL,
	[DefaultGLCompanySource] [smallint] NULL,
	[POHeaderStandardTextKey] [int] NULL,
	[POFooterStandardTextKey] [int] NULL,
	[IOHeaderStandardTextKey] [int] NULL,
	[IOFooterStandardTextKey] [int] NULL,
	[BOHeaderStandardTextKey] [int] NULL,
	[BOFooterStandardTextKey] [int] NULL,
	[EmailProtocol] [tinyint] NULL,
	[RequireProjectType] [tinyint] NULL,
	[ShowICTSetup] [tinyint] NULL,
	[ShowActualHours] [tinyint] NULL,
	[UseAlternatePayer] [tinyint] NULL,
	[MultiCompanyClosingDate] [tinyint] NULL,
	[RequireOfficeOnHeaders] [tinyint] NULL,
	[InternalReviewReminderType] [tinyint] NULL,
	[ClientReviewReminderType] [tinyint] NULL,
	[DeliverableStatus] [smalldatetime] NULL,
	[InternalReviewReminderInterval] [int] NULL,
	[ClientReviewReminderInterval] [int] NULL,
	[CustomReportAssignedProjectOnly] [tinyint] NULL,
	[EmailTimeSubmittal] [tinyint] NULL,
	[NoTimeBeforeGLCloseDate] [tinyint] NULL,
	[ForecastLaborAccountKey] [int] NULL,
	[ForecastProductionAccountKey] [int] NULL,
	[ForecastMediaAccountKey] [int] NULL,
	[DiaryFont] [varchar](100) NULL,
	[DiaryFontSize] [int] NULL,
	[EmailSubjectFormat] [int] NULL,
	[Culture] [int] NULL,
	[LanguageID] [varchar](10) NULL,
	[ApplicationName] [varchar](200) NULL,
	[VendorInvoiceApproverNotification] [tinyint] NULL,
	[DFAUserID] [varchar](100) NULL,
	[DFAPassword] [varchar](100) NULL,
	[ClientInvoiceApproverNotification] [tinyint] NULL,
	[EmailFooter] [text] NULL,
	[UnsubmittedTimeSheet] [datetime] NULL,
	[UnsubmittedTimeSheetFreq] [smallint] NULL,
	[OnlyOneApprovedEstimate] [tinyint] NULL,
	[CalendarNotificationsToStaffOnly] [tinyint] NULL,
	[ProjectFileSize] [bigint] NULL,
	[ReviewFileSize] [bigint] NULL,
	[FileSizeDate] [smalldatetime] NULL,
	[NextMediaWorksheetNum] [int] NULL,
	[RequireCampaignProjectClientMatch] [tinyint] NULL,
	[CurrencyID] [varchar](10) NULL,
	[RealizedGainAccountKey] [int] NULL,
	[MultiCurrency] [tinyint] NULL,
	[RoundingDiffAccountKey] [int] NULL,
	[IOShowPremiumsAsSingleLine] [tinyint] NULL,
	[IOOneBuyPerPage] [tinyint] NULL,
	[IOHideUserDefined1] [tinyint] NULL,
	[IOHideUserDefined2] [tinyint] NULL,
	[IOHideUserDefined3] [tinyint] NULL,
	[IOHideUserDefined4] [tinyint] NULL,
	[IOHideUserDefined5] [tinyint] NULL,
	[IOHideUserDefined6] [tinyint] NULL,
	[PwdRequireSpecialChars] [tinyint] NULL,
	[PwdRequireCapital] [tinyint] NULL,
	[PwdRequireLowerCase] [tinyint] NULL,
	[PwdNotSimilarToUserID] [tinyint] NULL,
	[PwdChangeOnFirstLogin] [tinyint] NULL,
	[NextIntNum] [int] NULL,
	[IntNumPrefix] [varchar](10) NULL,
	[IntNumPlaces] [int] NULL,
	[NextMediaWorksheetIntNum] [int] NULL,
	[NextMediaWorksheetBCNum] [int] NULL,
	[NextMediaWorksheetOOHNum] [int] NULL,
	[WIPMiscCostAtGross] [tinyint] NULL,
	[CreditCardPayment] [tinyint] NULL,
	[ForecastCostAccountKey] [int] NULL,
	[ShowReviewsTab] [tinyint] NULL,
	[CloseMonthBLInvoice] [tinyint] NULL,
	[UseBillingTitles] [tinyint] NULL,
	[RequireUniqueIDOnProdDiv] [tinyint] NULL,
	[RequireProducts] [tinyint] NULL,
	[RequireDivisions] [tinyint] NULL,
	[UseWWP] [tinyint] NULL,
	[TitleRateSheetKey] [int] NULL,
	[RequireLoginForCC] [tinyint] NULL,
	[PostCCWhenSentToVendor] [tinyint] NULL,
	[WIPHoldTransactionNotPosted] [tinyint] NOT NULL,
	[AllowTransferDate] [tinyint] NULL,
	[APIAccessToken] [varchar](max) NULL,
	[DefaultDepartmentFromUser] [tinyint] NULL,
	[UndoWOAfterWIP] [tinyint] NULL,
	[UpdateActualsOnBWS] [tinyint] NULL,
	[DefaultIssueTypeKey] [int] NULL,
	[DefaultIssueStatusKey] [int] NULL,
 CONSTRAINT [tPreference_PK] PRIMARY KEY CLUSTERED 
(
	[CompanyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tPreference]  WITH CHECK ADD  CONSTRAINT [tCompany_tPreference_FK1] FOREIGN KEY([CompanyKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tPreference] CHECK CONSTRAINT [tCompany_tPreference_FK1]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_AutoScheduleProjects]  DEFAULT ((1)) FOR [AutoScheduleProjects]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_PONumStyle]  DEFAULT ((1)) FOR [ProjectNumStyle]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ProjectNumPrefixUseYear]  DEFAULT ((0)) FOR [ProjectNumPrefixUseYear]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_DefaultARApprover]  DEFAULT ((0)) FOR [DefaultARApprover]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_RequireGLAccounts]  DEFAULT ((0)) FOR [RequireGLAccounts]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_UseGL]  DEFAULT ((0)) FOR [PostToGL]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_TrackWIP]  DEFAULT ((0)) FOR [TrackWIP]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_RequireItems]  DEFAULT ((0)) FOR [RequireItems]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_FirstMonth]  DEFAULT ((1)) FOR [FirstMonth]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_NextJournalNumber]  DEFAULT ((0)) FOR [NextJournalNumber]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_PostSalesUsingDetail]  DEFAULT ((0)) FOR [PostSalesUsingDetail]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_TrackOverUnder]  DEFAULT ((0)) FOR [TrackOverUnder]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ProductVersion]  DEFAULT ('CM') FOR [ProductVersion]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_RequireRequest]  DEFAULT ((0)) FOR [RequireRequest]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_TrackQuantityOnHand]  DEFAULT ((0)) FOR [TrackQuantityOnHand]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ShowLogo]  DEFAULT ((1)) FOR [ShowLogo]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_GetRateFrom]  DEFAULT ((2)) FOR [GetRateFrom]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_GetMarkupFrom]  DEFAULT ((2)) FOR [GetMarkupFrom]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ItemMarkup]  DEFAULT ((0)) FOR [ItemMarkup]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_GetItemRate]  DEFAULT ((0)) FOR [GetItemRate]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_RequireTask]  DEFAULT ((1)) FOR [RequireTasks]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_RequireClass]  DEFAULT ((0)) FOR [RequireClasses]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ShowCustomRptConditions]  DEFAULT ((0)) FOR [ShowCustomRptConditions]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_SetInvoiceNumberOnApproval]  DEFAULT ((0)) FOR [SetInvoiceNumberOnApproval]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_RequireTimeDetails]  DEFAULT ((0)) FOR [RequireTimeDetails]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ProjectNumStyle1]  DEFAULT ((1)) FOR [EstimateNumStyle]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ProjectNumPrefixUseYear1]  DEFAULT ((0)) FOR [EstimateNumPrefixUseYear]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_Customizations]  DEFAULT ('trackcash') FOR [Customizations]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_UnverifiedTimeOption]  DEFAULT ((0)) FOR [UnverifiedTimeOption]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_CampaignNumStyle]  DEFAULT ((4)) FOR [CampaignNumStyle]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_CampaignNumPrefix]  DEFAULT ((11)) FOR [CampaignNumPrefix]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_NextCampaignNumber]  DEFAULT ((1)) FOR [NextCampaignNum]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_CampaignNumPlaces]  DEFAULT ((4)) FOR [CampaignNumPlaces]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_CampaignNumSep]  DEFAULT ('-') FOR [CampaignNumSep]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_CampaignNumPrefixUseYear]  DEFAULT ((1)) FOR [CampaignNumPrefixUseYear]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_AdvBillAccountOnly]  DEFAULT ((0)) FOR [AdvBillAccountOnly]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_UseSalesTaxOnExpenseReports]  DEFAULT ((0)) FOR [UseSalesTaxOnExpenseReports]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_UseAdvancedProjectDiary]  DEFAULT ((0)) FOR [UseAdvProjectDiary]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_DefaultGLCompanySource]  DEFAULT ((0)) FOR [DefaultGLCompanySource]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_EmailProtocol]  DEFAULT ((0)) FOR [EmailProtocol]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ShowICTSetup]  DEFAULT ((0)) FOR [ShowICTSetup]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_UseAlternatePayer]  DEFAULT ((0)) FOR [UseAlternatePayer]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_MultiCompanyClosingDate]  DEFAULT ((0)) FOR [MultiCompanyClosingDate]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_RequireOfficeOnHeaders]  DEFAULT ((0)) FOR [RequireOfficeOnHeaders]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_CustomReportAssignedProjectOnly]  DEFAULT ((0)) FOR [CustomReportAssignedProjectOnly]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_EmailTimeSubmittal]  DEFAULT ((0)) FOR [EmailTimeSubmittal]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_NoTimeBeforeGLCloseDate]  DEFAULT ((0)) FOR [NoTimeBeforeGLCloseDate]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_EmailSubjectFormat]  DEFAULT ((0)) FOR [EmailSubjectFormat]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_Culture]  DEFAULT ((1033)) FOR [Culture]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_VendorInvoiceApproverNotification]  DEFAULT ((0)) FOR [VendorInvoiceApproverNotification]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_ClientInvoiceApproverNotification]  DEFAULT ((0)) FOR [ClientInvoiceApproverNotification]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_MultiCurrency]  DEFAULT ((0)) FOR [MultiCurrency]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_IntNumPrefix]  DEFAULT ('INT') FOR [IntNumPrefix]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_IntNumPlaces]  DEFAULT ((5)) FOR [IntNumPlaces]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_CloseMonthBLInvoice]  DEFAULT ((0)) FOR [CloseMonthBLInvoice]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_WIPHoldTransactionNotPosted]  DEFAULT ((0)) FOR [WIPHoldTransactionNotPosted]
GO
ALTER TABLE [dbo].[tPreference] ADD  CONSTRAINT [DF_tPreference_AllowTransferDate]  DEFAULT ((1)) FOR [AllowTransferDate]
GO
