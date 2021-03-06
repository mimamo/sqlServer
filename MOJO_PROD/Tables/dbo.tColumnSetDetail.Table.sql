USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tColumnSetDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tColumnSetDetail](
	[ColumnSetDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[ColumnSetKey] [int] NOT NULL,
	[DisplayOrder] [int] NULL,
	[HeaderLabel] [varchar](200) NULL,
	[Source] [smallint] NULL,
	[Period] [varchar](20) NULL,
	[StartOffset] [int] NULL,
	[EndOffset] [int] NULL,
	[Calculation] [varchar](500) NULL,
	[YearOffset] [int] NULL,
 CONSTRAINT [PK_tColumnSetDetail] PRIMARY KEY CLUSTERED 
(
	[ColumnSetDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
