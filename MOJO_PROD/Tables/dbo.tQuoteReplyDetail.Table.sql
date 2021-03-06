USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tQuoteReplyDetail]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tQuoteReplyDetail](
	[QuoteReplyDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[QuoteReplyKey] [int] NOT NULL,
	[QuoteDetailKey] [int] NULL,
	[Comments] [varchar](1000) NULL,
	[UnitCost] [money] NULL,
	[TotalCost] [money] NULL,
	[CloseDate] [smalldatetime] NULL,
	[MaterialDueDate] [smalldatetime] NULL,
	[UnitCost2] [money] NULL,
	[TotalCost2] [money] NULL,
	[UnitCost3] [money] NULL,
	[TotalCost3] [money] NULL,
	[UnitCost4] [money] NULL,
	[TotalCost4] [money] NULL,
	[UnitCost5] [money] NULL,
	[TotalCost5] [money] NULL,
	[UnitCost6] [money] NULL,
	[TotalCost6] [money] NULL,
 CONSTRAINT [PK_tQuoteReplyDetail] PRIMARY KEY NONCLUSTERED 
(
	[QuoteReplyDetailKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tQuoteReplyDetail]  WITH CHECK ADD  CONSTRAINT [FK_tQuoteReplyDetail_tQuoteDetail] FOREIGN KEY([QuoteDetailKey])
REFERENCES [dbo].[tQuoteDetail] ([QuoteDetailKey])
GO
ALTER TABLE [dbo].[tQuoteReplyDetail] CHECK CONSTRAINT [FK_tQuoteReplyDetail_tQuoteDetail]
GO
ALTER TABLE [dbo].[tQuoteReplyDetail]  WITH CHECK ADD  CONSTRAINT [FK_tQuoteReplyDetail_tQuoteReply] FOREIGN KEY([QuoteReplyKey])
REFERENCES [dbo].[tQuoteReply] ([QuoteReplyKey])
GO
ALTER TABLE [dbo].[tQuoteReplyDetail] CHECK CONSTRAINT [FK_tQuoteReplyDetail_tQuoteReply]
GO
