USE [DAL_TEST_APP]
GO
/****** Object:  Table [dbo].[CustEDD]    Script Date: 12/21/2015 13:56:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustEDD](
	[BodyText] [char](255) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](47) NOT NULL,
	[CustID] [char](15) NOT NULL,
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
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](47) NOT NULL,
	[NoteId] [int] NOT NULL,
	[NotifyOptions] [char](1) NOT NULL,
	[PrintOption] [char](1) NOT NULL,
	[Priority] [char](1) NOT NULL,
	[RequestorsEmail] [char](80) NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[SendersEmail] [char](80) NOT NULL,
	[ShipToID] [char](10) NOT NULL,
	[SubjectText] [char](80) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[TStamp] [timestamp] NOT NULL,
 CONSTRAINT [CustEDD0] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[DocType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
