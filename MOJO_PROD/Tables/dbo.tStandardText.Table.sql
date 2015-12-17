USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tStandardText]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tStandardText](
	[StandardTextKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Type] [varchar](20) NOT NULL,
	[TextName] [varchar](100) NULL,
	[StandardText] [text] NULL,
	[Active] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tStandardText] PRIMARY KEY NONCLUSTERED 
(
	[StandardTextKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tStandardText] ADD  CONSTRAINT [DF_tStandardText_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tStandardText] ADD  CONSTRAINT [DF_tStandardText_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
