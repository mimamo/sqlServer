USE [MID_DEV_APP]
GO
/****** Object:  Table [dbo].[EmpEDD]    Script Date: 12/21/2015 14:16:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmpEDD](
	[BodyText] [char](255) NOT NULL,
	[EmpID] [char](10) NOT NULL,
	[DeliveryMethod] [char](1) NOT NULL,
	[DocsDeliveredNbr] [char](1) NOT NULL,
	[DocType] [char](2) NOT NULL,
	[EDD] [char](1) NOT NULL,
	[EDDEmail] [char](80) NOT NULL,
	[EDDFax] [char](10) NOT NULL,
	[EDDFaxPrefix] [char](15) NOT NULL,
	[EDDFaxUseAreaCode] [smallint] NOT NULL,
	[EmailFileType] [char](1) NOT NULL,
	[FaxComment] [char](1) NOT NULL,
	[FaxCover] [char](1) NOT NULL,
	[FaxReceiverName] [char](60) NOT NULL,
	[FaxRecycle] [char](1) NOT NULL,
	[FaxReply] [char](1) NOT NULL,
	[FaxReview] [char](1) NOT NULL,
	[FaxSenderName] [char](60) NOT NULL,
	[FaxSenderNbr] [char](10) NOT NULL,
	[FaxUrgent] [char](1) NOT NULL,
	[NotifyOptions] [char](1) NOT NULL,
	[PrintOption] [char](1) NOT NULL,
	[Priority] [char](1) NOT NULL,
	[RequestorsEmail] [char](80) NOT NULL,
	[SendersEmail] [char](80) NOT NULL,
	[SubjectText] [char](80) NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [EmpEDD0] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC,
	[DocType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
