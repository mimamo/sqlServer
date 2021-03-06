USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xAPJDOCNUM]    Script Date: 12/21/2015 15:42:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xAPJDOCNUM](
	[APrevTS] [bigint] NOT NULL,
	[ACurrTS] [bigint] NOT NULL,
	[ASolomonUserID] [varchar](47) NOT NULL,
	[ASqlUserID] [varchar](50) NOT NULL,
	[AComputerName] [varchar](50) NOT NULL,
	[ADate] [smalldatetime] NOT NULL,
	[ATime] [varchar](12) NOT NULL,
	[AProcess] [char](1) NOT NULL,
	[AApplication] [varchar](40) NOT NULL,
	[AutoNum_labhdr] [smallint] NULL,
	[LastUsed_labhdr] [varchar](10) NULL,
	[AutoNum_chargh] [smallint] NULL,
	[LastUsed_chargh] [varchar](10) NULL,
	[AutoNum_alloc] [smallint] NULL,
	[LastUsed_alloc] [varchar](10) NULL,
	[AutoNum_tran] [smallint] NULL,
	[LastUsed_tran] [varchar](10) NULL,
	[AutoNum_foreign] [smallint] NULL,
	[LastUsed_foreign] [varchar](10) NULL,
	[AutoNum_revenue] [smallint] NULL,
	[LastUsed_revenue] [varchar](10) NULL,
	[AutoNum_1] [smallint] NULL,
	[LastUsed_1] [varchar](10) NULL,
	[AutoNum_2] [smallint] NULL,
	[LastUsed_2] [varchar](10) NULL,
	[AutoNum_3] [smallint] NULL,
	[LastUsed_3] [varchar](10) NULL,
	[AutoNum_4] [smallint] NULL,
	[LastUsed_4] [varchar](10) NULL,
	[AutoNum_5] [smallint] NULL,
	[LastUsed_5] [varchar](10) NULL,
	[AutoNum_6] [smallint] NULL,
	[LastUsed_6] [varchar](10) NULL,
	[AutoNum_7] [smallint] NULL,
	[LastUsed_7] [varchar](10) NULL,
	[AutoNum_8] [smallint] NULL,
	[LastUsed_8] [varchar](10) NULL,
	[AutoNum_9] [smallint] NULL,
	[LastUsed_9] [varchar](10) NULL,
	[AutoNum_10] [smallint] NULL,
	[LastUsed_10] [varchar](10) NULL,
	[AutoNum_11] [smallint] NULL,
	[LastUsed_11] [varchar](10) NULL,
	[AutoNum_12] [smallint] NULL,
	[LastUsed_12] [varchar](10) NULL,
	[Id] [varchar](10) NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_Prog] [varchar](8) NULL,
	[Crtd_User] [varchar](10) NULL,
	[LUpd_DateTime] [smalldatetime] NULL,
	[LUpd_Prog] [varchar](8) NULL,
	[LUpd_User] [varchar](10) NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_APrevTS]  DEFAULT ((0)) FOR [APrevTS]
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_ACurrTS]  DEFAULT ((0)) FOR [ACurrTS]
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_ASolomonUserID]  DEFAULT (' ') FOR [ASolomonUserID]
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_ASqlUserID]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(original_login())),(0))) FOR [ASqlUserID]
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_AComputerName]  DEFAULT (CONVERT([varchar](50),ltrim(rtrim(host_name())),0)) FOR [AComputerName]
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_ADate]  DEFAULT (CONVERT([smalldatetime],CONVERT([char](16),getdate(),(121)),0)) FOR [ADate]
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_ATime]  DEFAULT (CONVERT([varchar](12),getdate(),(114))) FOR [ATime]
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_AProcess]  DEFAULT (' ') FOR [AProcess]
GO
ALTER TABLE [dbo].[xAPJDOCNUM] ADD  CONSTRAINT [DF_xAPJDOCNUM_AApplication]  DEFAULT (CONVERT([varchar](40),ltrim(rtrim(app_name())),0)) FOR [AApplication]
GO
