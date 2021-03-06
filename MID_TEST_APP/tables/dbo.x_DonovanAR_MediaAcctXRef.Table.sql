USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[x_DonovanAR_MediaAcctXRef]    Script Date: 12/21/2015 14:26:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[x_DonovanAR_MediaAcctXRef](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MediaType] [varchar](1) NOT NULL,
	[MediaTypeDesc] [varchar](30) NOT NULL,
	[SalesAcct] [varchar](10) NOT NULL,
	[COSAcct] [varchar](10) NOT NULL,
	[ARAcct] [varchar](10) NOT NULL,
	[PayableAcct] [varchar](10) NOT NULL,
	[SalesSub] [varchar](24) NOT NULL,
	[COSSub] [varchar](24) NOT NULL,
	[ARSub] [varchar](24) NOT NULL,
	[PayableSub] [varchar](24) NOT NULL,
 CONSTRAINT [PK_x_DonovanAR_MediaAcctXRef] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaAcctXRef_MediaType]  DEFAULT ('') FOR [MediaType]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaAcctXRef_MediaTypeDesc]  DEFAULT ('') FOR [MediaTypeDesc]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaAcctXRef_SalesAcct]  DEFAULT ('') FOR [SalesAcct]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaAcctXRef_COSAcct]  DEFAULT ('') FOR [COSAcct]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaAcctXRef_ARAcct]  DEFAULT ('') FOR [ARAcct]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaAcctXRef_PayableAcct]  DEFAULT ('') FOR [PayableAcct]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaSubXRef_SalesSub]  DEFAULT ('') FOR [SalesSub]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaSubXRef_COSSub]  DEFAULT ('') FOR [COSSub]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaSubXRef_ARSub]  DEFAULT ('') FOR [ARSub]
GO
ALTER TABLE [dbo].[x_DonovanAR_MediaAcctXRef] ADD  CONSTRAINT [DF_x_DonovanAR_MediaSubXRef_PayableSub]  DEFAULT ('') FOR [PayableSub]
GO
