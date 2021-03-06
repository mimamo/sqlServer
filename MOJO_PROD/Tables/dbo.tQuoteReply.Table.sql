USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tQuoteReply]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tQuoteReply](
	[QuoteReplyKey] [int] IDENTITY(1,1) NOT NULL,
	[QuoteKey] [int] NOT NULL,
	[QuoteReplyNumber] [int] NULL,
	[VendorKey] [int] NOT NULL,
	[ContactKey] [int] NULL,
	[Status] [smallint] NULL,
	[SpecialComments] [varchar](4000) NULL,
	[AddressKey] [int] NULL,
 CONSTRAINT [PK_tQuoteReply] PRIMARY KEY NONCLUSTERED 
(
	[QuoteReplyKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tQuoteReply]  WITH NOCHECK ADD  CONSTRAINT [FK_tQuoteReply_tQuote] FOREIGN KEY([QuoteKey])
REFERENCES [dbo].[tQuote] ([QuoteKey])
GO
ALTER TABLE [dbo].[tQuoteReply] CHECK CONSTRAINT [FK_tQuoteReply_tQuote]
GO
ALTER TABLE [dbo].[tQuoteReply] ADD  CONSTRAINT [DF_tQuoteReply_Status]  DEFAULT ((1)) FOR [Status]
GO
