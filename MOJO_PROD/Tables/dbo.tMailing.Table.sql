USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMailing]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMailing](
	[MailingKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[MailingName] [varchar](500) NULL,
	[MailingID] [varchar](100) NULL,
	[DateAdded] [smalldatetime] NULL,
	[DateUpdated] [smalldatetime] NULL,
	[EmailSentActivityKey] [int] NULL,
	[EmailClickedActivityKey] [int] NULL,
 CONSTRAINT [PK_tMailing] PRIMARY KEY CLUSTERED 
(
	[MailingKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
