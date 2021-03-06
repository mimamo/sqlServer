USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaPremiumDetail]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaPremiumDetail](
	[MediaPremiumDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[MediaPremiumKey] [int] NOT NULL,
	[CompanyMediaKey] [int] NULL,
	[EndDate] [smalldatetime] NULL,
	[AmountType] [varchar](50) NULL,
	[Amount] [decimal](24, 4) NULL,
	[CostBase] [varchar](50) NULL,
	[Commissionable] [tinyint] NULL,
	[Taxable] [tinyint] NULL,
	[Description] [varchar](max) NULL,
	[StartDate] [smalldatetime] NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[AddedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_tMediaPremiumDetail] PRIMARY KEY CLUSTERED 
(
	[MediaPremiumDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaPremiumDetail]  WITH CHECK ADD  CONSTRAINT [FK_tMediaPremiumDetail_tMediaPremium] FOREIGN KEY([MediaPremiumKey])
REFERENCES [dbo].[tMediaPremium] ([MediaPremiumKey])
GO
ALTER TABLE [dbo].[tMediaPremiumDetail] CHECK CONSTRAINT [FK_tMediaPremiumDetail_tMediaPremium]
GO
