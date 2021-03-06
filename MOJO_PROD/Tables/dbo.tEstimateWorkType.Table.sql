USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tEstimateWorkType]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tEstimateWorkType](
	[EstimateKey] [int] NOT NULL,
	[WorkTypeKey] [int] NOT NULL,
	[Subject] [varchar](200) NULL,
	[Description] [text] NULL,
 CONSTRAINT [PK_tEstimateWorkType] PRIMARY KEY CLUSTERED 
(
	[EstimateKey] ASC,
	[WorkTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
