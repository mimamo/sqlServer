USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tVPaymentLog]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tVPaymentLog](
	[VPaymentLogKey] [uniqueidentifier] NOT NULL,
	[CompanyKey] [int] NULL,
	[ActionDate] [smalldatetime] NULL,
	[UserKey] [int] NULL,
	[Method] [varchar](50) NULL,
	[QS] [varchar](max) NULL,
	[Response] [varchar](max) NULL,
 CONSTRAINT [PK_tVPaymentLog] PRIMARY KEY CLUSTERED 
(
	[VPaymentLogKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
