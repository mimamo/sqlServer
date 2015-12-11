USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tItemRateSheetDetail]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tItemRateSheetDetail](
	[ItemRateSheetKey] [int] NOT NULL,
	[ItemKey] [int] NOT NULL,
	[Markup] [decimal](24, 4) NULL,
	[UnitRate] [money] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tItemRateSheetDetail] PRIMARY KEY CLUSTERED 
(
	[ItemRateSheetKey] ASC,
	[ItemKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tItemRateSheetDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_tItemRateSheetDetail_tItemRateSheet] FOREIGN KEY([ItemRateSheetKey])
REFERENCES [dbo].[tItemRateSheet] ([ItemRateSheetKey])
GO
ALTER TABLE [dbo].[tItemRateSheetDetail] CHECK CONSTRAINT [FK_tItemRateSheetDetail_tItemRateSheet]
GO
ALTER TABLE [dbo].[tItemRateSheetDetail] ADD  CONSTRAINT [DF_tItemRateSheetDetail_Markup]  DEFAULT ((0)) FOR [Markup]
GO
ALTER TABLE [dbo].[tItemRateSheetDetail] ADD  CONSTRAINT [DF_tItemRateSheetDetail_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
