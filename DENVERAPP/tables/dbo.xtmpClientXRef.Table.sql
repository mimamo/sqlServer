USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[xtmpClientXRef]    Script Date: 12/21/2015 15:42:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xtmpClientXRef](
	[dslClientCode] [varchar](255) NULL,
	[clientCode] [varchar](255) NULL,
	[plUnitCode] [varchar](255) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
