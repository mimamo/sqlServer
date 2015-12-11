USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tUser]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tUser](
	[UserKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[FirstName] [varchar](100) NULL,
	[MiddleName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[Salutation] [varchar](10) NULL,
	[DepartmentKey] [int] NULL,
	[Phone1] [varchar](50) NULL,
	[Phone2] [varchar](50) NULL,
	[Cell] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Pager] [varchar](50) NULL,
	[Title] [varchar](200) NULL,
	[Email] [varchar](100) NULL,
	[SecurityGroupKey] [int] NULL,
	[Administrator] [tinyint] NULL,
	[UserID] [varchar](100) NULL,
	[Password] [varchar](500) NULL,
	[SystemID] [varchar](500) NULL,
	[OwnerCompanyKey] [int] NULL,
	[LastLogin] [smalldatetime] NULL,
	[ContactMethod] [tinyint] NULL,
	[Active] [tinyint] NULL,
	[AutoAssign] [tinyint] NULL,
	[NoUnassign] [tinyint] NULL,
	[HourlyRate] [money] NULL,
	[HourlyCost] [money] NULL,
	[TimeApprover] [int] NULL,
	[ExpenseApprover] [int] NULL,
	[POLimit] [money] NULL,
	[BCLimit] [money] NULL,
	[IOLimit] [money] NULL,
	[VendorKey] [int] NULL,
	[ClassKey] [int] NULL,
	[CustomFieldKey] [int] NULL,
	[InOutStatus] [varchar](10) NULL,
	[InOutNotes] [varchar](100) NULL,
	[UserDefined1] [varchar](250) NULL,
	[UserDefined2] [varchar](250) NULL,
	[UserDefined3] [varchar](250) NULL,
	[UserDefined4] [varchar](250) NULL,
	[UserDefined5] [varchar](250) NULL,
	[UserDefined6] [varchar](250) NULL,
	[UserDefined7] [varchar](250) NULL,
	[UserDefined8] [varchar](250) NULL,
	[UserDefined9] [varchar](250) NULL,
	[UserDefined10] [varchar](250) NULL,
	[OfficeKey] [int] NULL,
	[RateLevel] [int] NULL,
	[TrafficNotification] [tinyint] NULL,
	[ClientVendorLogin] [tinyint] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[TimeZoneIndex] [int] NULL,
	[NumberOfAttempts] [int] NULL,
	[Locked] [tinyint] NULL,
	[LastPwdChange] [smalldatetime] NULL,
	[Supervisor] [tinyint] NULL,
	[DefaultReminderTime] [int] NULL,
	[LinkID] [varchar](100) NULL,
	[AddressKey] [int] NULL,
	[DefaultServiceKey] [int] NULL,
	[SystemMessage] [tinyint] NULL,
	[GLCompanyKey] [int] NULL,
	[MonthlyCost] [money] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[OwnerKey] [int] NULL,
	[CMFolderKey] [int] NULL,
	[DoNotCall] [tinyint] NULL,
	[DoNotEmail] [tinyint] NULL,
	[DoNotMail] [tinyint] NULL,
	[DoNotFax] [tinyint] NULL,
	[AddedByKey] [int] NULL,
	[UpdatedByKey] [int] NULL,
	[HomeAddressKey] [int] NULL,
	[OtherAddressKey] [int] NULL,
	[ClientDivisionKey] [int] NULL,
	[ClientProductKey] [int] NULL,
	[Department] [varchar](300) NULL,
	[UserRole] [varchar](300) NULL,
	[ReportsToKey] [int] NULL,
	[Assistant] [varchar](300) NULL,
	[AssistantPhone] [varchar](50) NULL,
	[AssistantEmail] [varchar](100) NULL,
	[Birthday] [datetime] NULL,
	[SpouseName] [varchar](300) NULL,
	[Children] [varchar](500) NULL,
	[Anniversary] [datetime] NULL,
	[Hobbies] [varchar](500) NULL,
	[Comments] [text] NULL,
	[UserCompanyName] [varchar](200) NULL,
	[LastActivityKey] [int] NULL,
	[NextActivityKey] [int] NULL,
	[DefaultCMFolderKey] [int] NULL,
	[WWPCurrentLevel] [int] NULL,
	[DefaultCalendarColor] [varchar](50) NULL,
	[DateConverted] [smalldatetime] NULL,
	[DefaultContactCMFolderKey] [int] NULL,
	[SyncMLDirection] [smallint] NULL,
	[CalendarReminder] [smallint] NULL,
	[DateLeadCreated] [smalldatetime] NULL,
	[QuickMeeting] [tinyint] NULL,
	[LinkedCompanyAddressKey] [int] NULL,
	[MarketingMessage] [varchar](2000) NULL,
	[SubscribeDiary] [tinyint] NULL,
	[SubscribeToDo] [tinyint] NULL,
	[DeliverableReviewer] [tinyint] NULL,
	[DeliverableNotify] [tinyint] NULL,
	[RightLevel] [int] NULL,
	[Contractor] [tinyint] NULL,
	[RequireUserTimeDetails] [tinyint] NULL,
	[CreditCardApprover] [int] NULL,
	[BackupApprover] [int] NULL,
	[DateHired] [smalldatetime] NULL,
	[ExternalMarketingKey] [int] NULL,
	[LanguageID] [varchar](10) NULL,
	[ForcePwdChangeOnNextLogin] [tinyint] NULL,
	[Uid] [varchar](2500) NOT NULL,
	[OriginalVCard] [varchar](max) NULL,
	[GoogleAuthToken] [varchar](1000) NULL,
	[GoogleAuthTokenExpires] [smalldatetime] NULL,
	[GoogleRefreshToken] [varchar](1000) NULL,
	[GoogleRefreshTokenExpires] [smalldatetime] NULL,
	[TitleKey] [int] NULL,
	[InvoiceEmails] [varchar](1000) NULL,
	[TwitterID] [varchar](50) NULL,
	[LinkedInURL] [varchar](100) NULL,
	[Signature] [text] NULL,
 CONSTRAINT [tUser_PK] PRIMARY KEY CLUSTERED 
(
	[UserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tUser]  WITH NOCHECK ADD  CONSTRAINT [tSecurityGroup_tUser_FK1] FOREIGN KEY([SecurityGroupKey])
REFERENCES [dbo].[tSecurityGroup] ([SecurityGroupKey])
GO
ALTER TABLE [dbo].[tUser] CHECK CONSTRAINT [tSecurityGroup_tUser_FK1]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_Administrator]  DEFAULT ((0)) FOR [Administrator]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_NoUnassign]  DEFAULT ((0)) FOR [NoUnassign]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_POLimit]  DEFAULT ((0)) FOR [POLimit]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_BCLimit]  DEFAULT ((0)) FOR [BCLimit]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_IOLimit]  DEFAULT ((0)) FOR [IOLimit]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_RateLevel]  DEFAULT ((1)) FOR [RateLevel]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_TrafficNotification]  DEFAULT ((0)) FOR [TrafficNotification]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_ClientVendorLogin]  DEFAULT ((0)) FOR [ClientVendorLogin]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_DateAdded]  DEFAULT (getdate()) FOR [DateAdded]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_DateUpdated]  DEFAULT (getdate()) FOR [DateUpdated]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_Supervisor]  DEFAULT ((0)) FOR [Supervisor]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_SubscribeDiary]  DEFAULT ((0)) FOR [SubscribeDiary]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_SubscribeTodo]  DEFAULT ((0)) FOR [SubscribeToDo]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_Contractor]  DEFAULT ((0)) FOR [Contractor]
GO
ALTER TABLE [dbo].[tUser] ADD  CONSTRAINT [DF_tUser_Uid]  DEFAULT (newid()) FOR [Uid]
GO
