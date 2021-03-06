USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTimeRateSheet]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTimeRateSheet](
	[TimeRateSheetKey] [int] IDENTITY(1,1) NOT NULL,
	[RateSheetName] [varchar](100) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Active] [tinyint] NULL,
	[LastModified] [smalldatetime] NULL,
 CONSTRAINT [PK_tTimeRateSheet] PRIMARY KEY NONCLUSTERED 
(
	[TimeRateSheetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
