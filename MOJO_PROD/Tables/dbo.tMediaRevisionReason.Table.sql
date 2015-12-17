USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaRevisionReason]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaRevisionReason](
	[MediaRevisionReasonKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NULL,
	[ReasonID] [varchar](6) NULL,
	[Description] [varchar](100) NULL,
	[Active] [smallint] NULL,
 CONSTRAINT [PK_tMediaRevisionReason] PRIMARY KEY CLUSTERED 
(
	[MediaRevisionReasonKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaRevisionReason] ADD  CONSTRAINT [DF_tMediaRevisionReason_Active]  DEFAULT ((1)) FOR [Active]
GO
