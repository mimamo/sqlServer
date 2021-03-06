USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[cdosysmail_failures]    Script Date: 12/21/2015 16:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cdosysmail_failures](
	[Date of Failure] [datetime] NULL,
	[Spid] [int] NULL,
	[From] [varchar](100) NULL,
	[To] [varchar](100) NULL,
	[Subject] [varchar](100) NULL,
	[Body] [varchar](4000) NULL,
	[iMsg] [int] NULL,
	[Hr] [int] NULL,
	[Source of Failure] [varchar](255) NULL,
	[Description of Failure] [varchar](500) NULL,
	[Output from Failure] [varchar](1000) NULL,
	[Comment about Failure] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
