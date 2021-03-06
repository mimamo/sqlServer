USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectEstByItem]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectEstByItem](
	[ProjectKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Qty] [decimal](24, 4) NOT NULL,
	[Net] [money] NOT NULL,
	[Gross] [money] NOT NULL,
	[COQty] [decimal](24, 4) NOT NULL,
	[CONet] [money] NOT NULL,
	[COGross] [money] NOT NULL,
 CONSTRAINT [PK_tProjectEstByItem] PRIMARY KEY NONCLUSTERED 
(
	[ProjectKey] ASC,
	[Entity] ASC,
	[EntityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProjectEstByItem] ADD  CONSTRAINT [DF_tProjectEstByItem_Qty]  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [dbo].[tProjectEstByItem] ADD  CONSTRAINT [DF_tProjectEstByItem_COQty]  DEFAULT ((0)) FOR [COQty]
GO
