USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tQuote]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tQuote](
	[QuoteKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[PurchaseOrderTypeKey] [int] NULL,
	[QuoteNumber] [int] NULL,
	[ProjectKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ItemKey] [int] NULL,
	[Subject] [varchar](200) NOT NULL,
	[QuoteDate] [smalldatetime] NULL,
	[DueDate] [smalldatetime] NULL,
	[Description] [varchar](1000) NULL,
	[ApprovedReplyKey] [int] NULL,
	[Status] [smallint] NULL,
	[CustomFieldKey] [int] NULL,
	[SendRepliesTo] [int] NULL,
	[HeaderTextKey] [int] NULL,
	[FooterTextKey] [int] NULL,
	[MultipleQty] [tinyint] NULL,
	[Quote1] [varchar](100) NULL,
	[Quote2] [varchar](100) NULL,
	[Quote3] [varchar](100) NULL,
	[Quote4] [varchar](100) NULL,
	[Quote5] [varchar](100) NULL,
	[Quote6] [varchar](100) NULL,
	[GLCompanyKey] [int] NULL,
	[CompanyAddressKey] [int] NULL,
	[EstimateKey] [int] NULL,
 CONSTRAINT [PK_tQuote] PRIMARY KEY NONCLUSTERED 
(
	[QuoteKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
