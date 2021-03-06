USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRetainerItems]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tRetainerItems](
	[RetainerKey] [int] NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tRetainerItem] PRIMARY KEY NONCLUSTERED 
(
	[RetainerKey] ASC,
	[EntityKey] ASC,
	[Entity] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tRetainerItems]  WITH CHECK ADD  CONSTRAINT [FK_tRetainerItem_tRetainer] FOREIGN KEY([RetainerKey])
REFERENCES [dbo].[tRetainer] ([RetainerKey])
GO
ALTER TABLE [dbo].[tRetainerItems] CHECK CONSTRAINT [FK_tRetainerItem_tRetainer]
GO
