USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[PSSUpgradeAfter]    Script Date: 12/21/2015 14:05:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PSSUpgradeAfter](
	[Crtd_DateTime] [datetime] NULL,
	[SQLStmt] [nvarchar](4000) NULL,
	[TableName] [varchar](50) NULL,
	[UserName] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
