USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[xwrk_Client_Grp_Audit]    Script Date: 12/21/2015 16:12:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_Client_Grp_Audit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AUDIT_STAMP] [datetime] NOT NULL,
	[AUDIT_ACTN] [char](15) NOT NULL,
	[AUDIT_USER] [char](30) NOT NULL,
	[classGrp] [varchar](10) NULL,
	[classID] [varchar](10) NULL,
	[classDesc] [varchar](50) NULL,
	[clientID] [varchar](10) NULL,
	[clientName] [varchar](50) NULL,
	[prodID] [varchar](10) NULL,
	[prodDesc] [varchar](50) NULL,
	[POS] [varchar](20) NULL,
	[businessUnit] [varchar](50) NULL,
	[subUnit] [varchar](20) NULL,
	[brand] [varchar](20) NULL,
	[marketingType] [varchar](20) NULL,
	[director] [varchar](50) NULL,
	[CFA] [varchar](50) NULL,
	[EU_CM] [varchar](50) NULL,
	[EU_BM] [varchar](50) NULL,
	[EU_CH] [varchar](50) NULL,
	[EU_R] [varchar](50) NULL,
	[OPER_Category] [varchar](50) NULL,
	[OPER_Scope] [varchar](50) NULL,
	[OPER_Client] [varchar](50) NULL,
	[MC_Creative] [varchar](50) NULL,
	[gStatus] [varchar](1) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
