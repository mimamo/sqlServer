USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[PJDOCNUM]    Script Date: 12/21/2015 16:12:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJDOCNUM](
	[AutoNum_labhdr] [smallint] NOT NULL,
	[LastUsed_labhdr] [char](10) NOT NULL,
	[AutoNum_chargh] [smallint] NOT NULL,
	[LastUsed_chargh] [char](10) NOT NULL,
	[AutoNum_alloc] [smallint] NOT NULL,
	[LastUsed_alloc] [char](10) NOT NULL,
	[AutoNum_tran] [smallint] NOT NULL,
	[LastUsed_tran] [char](10) NOT NULL,
	[AutoNum_foreign] [smallint] NOT NULL,
	[LastUsed_foreign] [char](10) NOT NULL,
	[AutoNum_revenue] [smallint] NOT NULL,
	[LastUsed_revenue] [char](10) NOT NULL,
	[AutoNum_1] [smallint] NOT NULL,
	[LastUsed_1] [char](10) NOT NULL,
	[AutoNum_2] [smallint] NOT NULL,
	[LastUsed_2] [char](10) NOT NULL,
	[AutoNum_3] [smallint] NOT NULL,
	[LastUsed_3] [char](10) NOT NULL,
	[AutoNum_4] [smallint] NOT NULL,
	[LastUsed_4] [char](10) NOT NULL,
	[AutoNum_5] [smallint] NOT NULL,
	[LastUsed_5] [char](10) NOT NULL,
	[AutoNum_6] [smallint] NOT NULL,
	[LastUsed_6] [char](10) NOT NULL,
	[AutoNum_7] [smallint] NOT NULL,
	[LastUsed_7] [char](10) NOT NULL,
	[AutoNum_8] [smallint] NOT NULL,
	[LastUsed_8] [char](10) NOT NULL,
	[AutoNum_9] [smallint] NOT NULL,
	[LastUsed_9] [char](10) NOT NULL,
	[AutoNum_10] [smallint] NOT NULL,
	[LastUsed_10] [char](10) NOT NULL,
	[AutoNum_11] [smallint] NOT NULL,
	[LastUsed_11] [char](10) NOT NULL,
	[AutoNum_12] [smallint] NOT NULL,
	[LastUsed_12] [char](10) NOT NULL,
	[Id] [char](10) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjdocnum0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
