USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tWriteOffReason]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tWriteOffReason](
	[WriteOffReasonKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ReasonName] [varchar](200) NOT NULL,
	[Description] [varchar](4000) NULL,
	[Active] [tinyint] NOT NULL,
 CONSTRAINT [PK_tWriteOffReason] PRIMARY KEY CLUSTERED 
(
	[WriteOffReasonKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
