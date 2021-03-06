USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[xtmpPJProjXRef]    Script Date: 12/21/2015 14:05:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpPJProjXRef](
	[project] [char](16) NULL,
	[projectDesc] [char](30) NULL,
	[clientCode] [char](12) NULL,
	[productCode] [char](12) NULL,
	[jobCode] [char](12) NULL,
	[recID] [int] NULL,
	[projPrefix] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
