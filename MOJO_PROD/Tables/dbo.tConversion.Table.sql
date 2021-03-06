USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tConversion]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tConversion](
	[ConversionID] [varchar](50) NOT NULL,
	[StepOrder] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Message] [varchar](8000) NULL,
 CONSTRAINT [PK_tConvert] PRIMARY KEY CLUSTERED 
(
	[ConversionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
