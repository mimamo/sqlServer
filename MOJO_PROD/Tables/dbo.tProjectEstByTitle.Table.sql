USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectEstByTitle]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tProjectEstByTitle](
	[ProjectKey] [int] NOT NULL,
	[TitleKey] [int] NOT NULL,
	[Qty] [decimal](24, 4) NOT NULL,
	[Net] [money] NOT NULL,
	[Gross] [money] NOT NULL,
	[COQty] [decimal](24, 4) NOT NULL,
	[CONet] [money] NOT NULL,
	[COGross] [money] NOT NULL,
 CONSTRAINT [PK_tProjectEstByTitle] PRIMARY KEY NONCLUSTERED 
(
	[ProjectKey] ASC,
	[TitleKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tProjectEstByTitle] ADD  CONSTRAINT [DF_tProjectEstByTitle_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[tProjectEstByTitle] ADD  CONSTRAINT [DF_tProjectEstByTitle_COQty]  DEFAULT ((0)) FOR [COQty]
GO
