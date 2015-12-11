USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tConversionLog]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tConversionLog](
	[ConversionID] [varchar](50) NOT NULL,
	[Message] [varchar](8000) NOT NULL,
	[LastModified] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tConversionLog] ADD  CONSTRAINT [DF_tConvertLog_LastModified]  DEFAULT (getdate()) FOR [LastModified]
GO
