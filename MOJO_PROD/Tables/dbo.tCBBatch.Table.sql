USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCBBatch]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCBBatch](
	[CBBatchKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[AccountingDate] [smalldatetime] NOT NULL,
	[Type] [smallint] NOT NULL,
	[LaborRateSheetKey] [int] NULL,
	[ExpRateSheetKey] [int] NULL,
	[Adjusted] [tinyint] NULL,
 CONSTRAINT [PK_tCBBatch] PRIMARY KEY CLUSTERED 
(
	[CBBatchKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
