USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[ViewWork]    Script Date: 12/21/2015 15:42:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ViewWork](
	[SortOrder] [int] NOT NULL,
	[ViewName] [varchar](100) NOT NULL,
	[ViewCode] [varchar](7500) NOT NULL,
	[Scripted] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
