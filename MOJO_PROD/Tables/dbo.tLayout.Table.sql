USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLayout]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLayout](
	[LayoutKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[LayoutName] [varchar](500) NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[Active] [tinyint] NULL,
	[TaskDetailOption] [smallint] NULL,
	[TaskShowTransactions] [tinyint] NULL,
	[EstLineFormat] [smallint] NULL,
 CONSTRAINT [PK_tLayout] PRIMARY KEY CLUSTERED 
(
	[LayoutKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tLayout] ADD  CONSTRAINT [DF_tLayout_TaskShowTransactions]  DEFAULT ((0)) FOR [TaskShowTransactions]
GO
