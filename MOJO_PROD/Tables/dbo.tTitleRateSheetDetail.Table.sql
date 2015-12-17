USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTitleRateSheetDetail]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTitleRateSheetDetail](
	[TitleRateSheetDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[TitleRateSheetKey] [int] NOT NULL,
	[TitleKey] [int] NOT NULL,
	[HourlyRate] [money] NULL,
 CONSTRAINT [PK_tTitleRateSheetDetail] PRIMARY KEY CLUSTERED 
(
	[TitleRateSheetDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
