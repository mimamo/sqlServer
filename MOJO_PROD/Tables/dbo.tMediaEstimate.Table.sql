USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaEstimate]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaEstimate](
	[MediaEstimateKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[LinkID] [varchar](100) NULL,
	[ClientKey] [int] NOT NULL,
	[EstimateID] [varchar](50) NOT NULL,
	[EstimateName] [varchar](200) NOT NULL,
	[CampaignKey] [int] NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ClientDivisionKey] [int] NULL,
	[ClientProductKey] [int] NULL,
	[Description] [text] NULL,
	[FlightStartDate] [smalldatetime] NULL,
	[FlightEndDate] [smalldatetime] NULL,
	[Active] [tinyint] NULL,
	[IOOrderDisplayMode] [smallint] NULL,
	[BCOrderDisplayMode] [smallint] NULL,
	[FlightInterval] [tinyint] NULL,
	[ClassKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[OfficeKey] [int] NULL,
	[CampaignSegmentKey] [int] NULL,
	[IOBillAt] [smallint] NULL,
	[BCBillAt] [smallint] NULL,
 CONSTRAINT [PK_tMediaEstimate] PRIMARY KEY CLUSTERED 
(
	[MediaEstimateKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaEstimate]  WITH NOCHECK ADD  CONSTRAINT [FK_tMediaEstimate_tCampaign] FOREIGN KEY([CampaignKey])
REFERENCES [dbo].[tCampaign] ([CampaignKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tMediaEstimate] NOCHECK CONSTRAINT [FK_tMediaEstimate_tCampaign]
GO
ALTER TABLE [dbo].[tMediaEstimate]  WITH NOCHECK ADD  CONSTRAINT [FK_tMediaEstimate_tClientProduct] FOREIGN KEY([ClientProductKey])
REFERENCES [dbo].[tClientProduct] ([ClientProductKey])
GO
ALTER TABLE [dbo].[tMediaEstimate] NOCHECK CONSTRAINT [FK_tMediaEstimate_tClientProduct]
GO
ALTER TABLE [dbo].[tMediaEstimate]  WITH NOCHECK ADD  CONSTRAINT [FK_tMediaEstimate_tProject] FOREIGN KEY([ProjectKey])
REFERENCES [dbo].[tProject] ([ProjectKey])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[tMediaEstimate] NOCHECK CONSTRAINT [FK_tMediaEstimate_tProject]
GO
ALTER TABLE [dbo].[tMediaEstimate] ADD  CONSTRAINT [DF_tMediaEstimate_IOBillAt]  DEFAULT ((0)) FOR [IOBillAt]
GO
ALTER TABLE [dbo].[tMediaEstimate] ADD  CONSTRAINT [DF_tMediaEstimate_BCBillAt]  DEFAULT ((0)) FOR [BCBillAt]
GO
