USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaWorksheetBudget]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tMediaWorksheetBudget](
	[MediaWorksheetKey] [int] NOT NULL,
	[ItemKey] [int] NOT NULL,
	[Budget] [money] NULL,
 CONSTRAINT [PK_tMediaWorksheetBudget] PRIMARY KEY CLUSTERED 
(
	[MediaWorksheetKey] ASC,
	[ItemKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
