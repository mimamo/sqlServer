USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaWorksheet]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaWorksheet](
	[MediaWorksheetKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[WorksheetID] [varchar](50) NOT NULL,
	[WorksheetName] [varchar](1000) NOT NULL,
	[ClientKey] [int] NOT NULL,
	[ProjectKey] [int] NULL,
	[CreatedByKey] [int] NULL,
	[DateCreated] [smalldatetime] NOT NULL,
	[LastUpdatedBy] [int] NULL,
	[LastUpdateDate] [smalldatetime] NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL,
	[BillingBase] [smallint] NULL,
	[BillingAdjPercent] [decimal](24, 4) NULL,
	[BillingAdjBase] [smallint] NULL,
	[CommissionOnly] [tinyint] NULL,
	[Comments] [varchar](max) NULL,
	[LockBuyChanges] [tinyint] NULL,
	[LockOrdering] [tinyint] NULL,
	[LockBilling] [tinyint] NULL,
	[LockVoucher] [tinyint] NULL,
	[Active] [tinyint] NULL,
	[TaskKey] [int] NULL,
	[POKind] [smallint] NULL,
	[GLCompanyKey] [int] NULL,
	[ClientProductKey] [int] NULL,
	[PrimaryBuyerKey] [int] NULL,
	[Frequency] [varchar](50) NULL,
	[Revision] [int] NULL,
	[DefaultLen] [int] NULL,
	[MediaAuth] [varchar](200) NULL,
	[WorksheetPONumber] [varchar](200) NULL,
	[AuthorizedBy] [int] NULL,
	[AuthorizedDate] [smalldatetime] NULL,
	[BudgetVar] [int] NULL,
	[FilterOptions] [varchar](max) NULL,
	[OneBuyPerOrder] [tinyint] NULL,
	[DoNotAppendNewBuys] [tinyint] NULL,
 CONSTRAINT [PK_tMediaWorksheet] PRIMARY KEY CLUSTERED 
(
	[MediaWorksheetKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaWorksheet] ADD  CONSTRAINT [DF_tMediaWorksheet_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
