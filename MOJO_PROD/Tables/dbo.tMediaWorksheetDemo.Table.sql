USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaWorksheetDemo]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaWorksheetDemo](
	[MediaWorksheetDemoKey] [int] IDENTITY(1,1) NOT NULL,
	[MediaWorksheetKey] [int] NOT NULL,
	[MediaDemographicKey] [int] NOT NULL,
	[DemoType] [varchar](50) NULL,
	[DisplayOrder] [int] NULL,
 CONSTRAINT [PK_tMediaWorksheetDemo] PRIMARY KEY CLUSTERED 
(
	[MediaWorksheetDemoKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
