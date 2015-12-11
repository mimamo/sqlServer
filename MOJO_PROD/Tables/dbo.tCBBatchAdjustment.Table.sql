USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCBBatchAdjustment]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCBBatchAdjustment](
	[AdjustmentBatchKey] [int] NOT NULL,
	[BatchKey] [int] NOT NULL,
 CONSTRAINT [PK_tCBBatchAdjustment] PRIMARY KEY CLUSTERED 
(
	[AdjustmentBatchKey] ASC,
	[BatchKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
