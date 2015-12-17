USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCCEntrySplit]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCCEntrySplit](
	[CCEntryKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[VoucherKey] [int] NULL,
	[Amount] [money] NOT NULL
) ON [PRIMARY]
GO
