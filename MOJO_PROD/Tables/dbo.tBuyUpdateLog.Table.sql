USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tBuyUpdateLog]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tBuyUpdateLog](
	[BuyUpdateLogKey] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[UserKey] [int] NOT NULL,
	[ActionDate] [smalldatetime] NOT NULL,
	[MediaWorksheetKey] [int] NOT NULL,
	[PurchaseOrderKey] [int] NULL,
	[Action] [char](1) NULL,
	[POKind] [smallint] NULL,
	[InternalID] [int] NULL,
	[Status] [smallint] NULL,
	[Revision] [int] NULL,
	[Printed] [tinyint] NULL,
	[Emailed] [tinyint] NULL,
	[PurchaseOrderNumber] [varchar](30) NULL,
	[BillingBase] [smallint] NULL,
	[BillingAdjPercent] [decimal](24, 4) NULL,
	[BillingAdjBase] [smallint] NULL,
	[CompanyMediaKey] [int] NULL,
	[VendorKey] [int] NULL,
	[ItemKey] [int] NULL,
	[MediaUnitTypeKey] [int] NULL,
	[HeaderData] [varchar](max) NULL,
	[UpdateError] [varchar](max) NULL,
 CONSTRAINT [PK_tBuyUpdateLog] PRIMARY KEY CLUSTERED 
(
	[BuyUpdateLogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tBuyUpdateLog] ADD  CONSTRAINT [DF_tBuyUpdateLog_ActionDate]  DEFAULT (getutcdate()) FOR [ActionDate]
GO
