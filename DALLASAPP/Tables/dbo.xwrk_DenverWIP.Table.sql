USE [DALLASAPP]
GO
/****** Object:  Table [dbo].[xwrk_DenverWIP]    Script Date: 12/21/2015 13:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xwrk_DenverWIP](
	[Project] [char](16) NOT NULL,
	[WIPAmt] [float] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
