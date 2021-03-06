USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTransactionUnpostLog]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTransactionUnpostLog](
	[UnpostLogKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[EntityDate] [smalldatetime] NOT NULL,
	[PostingDate] [smalldatetime] NOT NULL,
	[UnpostedBy] [int] NOT NULL,
	[DateUnposted] [smalldatetime] NOT NULL,
	[ClientKey] [int] NULL,
	[VendorKey] [int] NULL,
	[GLCompanyKey] [int] NULL,
	[ReferenceNumber] [varchar](100) NULL,
	[Description] [text] NULL,
 CONSTRAINT [PK_tTransactionUnpostLog] PRIMARY KEY CLUSTERED 
(
	[UnpostLogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
