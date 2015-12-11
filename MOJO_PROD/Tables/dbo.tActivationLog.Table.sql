USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tActivationLog]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tActivationLog](
	[ActivationKey] [int] IDENTITY(1,1) NOT NULL,
	[UserKey] [int] NOT NULL,
	[DateActivated] [smalldatetime] NULL,
	[DateDeactivated] [smalldatetime] NULL,
	[ActivatedByKey] [int] NULL,
	[DeactivatedByKey] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tActivationLog] ADD  CONSTRAINT [DF_tActivationLog_DateActivated]  DEFAULT (getdate()) FOR [DateActivated]
GO
