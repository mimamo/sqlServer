USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMailingSetup]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMailingSetup](
	[CompanyKey] [int] NOT NULL,
	[EmailSystem] [varchar](50) NULL,
	[UserID] [varchar](50) NULL,
	[Password] [varchar](200) NULL,
	[BBRemoveFromLists] [tinyint] NULL,
	[BBDelete] [tinyint] NULL,
	[SystemID] [varchar](50) NULL,
	[Initialized] [tinyint] NOT NULL,
	[AutoSync] [tinyint] NULL,
	[AddActivityForSentEmail] [tinyint] NULL,
	[AddActivityForBB] [tinyint] NULL,
	[AddActivityForClick] [tinyint] NULL,
	[BBDeactivate] [tinyint] NULL,
	[LastSync] [datetime] NULL,
	[MailingSetupKey] [int] IDENTITY(1,1) NOT NULL,
	[SyncUsers] [tinyint] NOT NULL,
	[AddActivityForOpens] [tinyint] NOT NULL,
	[AddActivityForEachClick] [tinyint] NULL,
 CONSTRAINT [PK_tMailingSetup] PRIMARY KEY CLUSTERED 
(
	[MailingSetupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMailingSetup] ADD  CONSTRAINT [DF_tMailingSetup_Initialized]  DEFAULT ((0)) FOR [Initialized]
GO
ALTER TABLE [dbo].[tMailingSetup] ADD  CONSTRAINT [DF_tMailingSetup_SyncUsers]  DEFAULT ((1)) FOR [SyncUsers]
GO
ALTER TABLE [dbo].[tMailingSetup] ADD  CONSTRAINT [DF_tMailingSetup_AddActivityForOpens]  DEFAULT ((0)) FOR [AddActivityForOpens]
GO
