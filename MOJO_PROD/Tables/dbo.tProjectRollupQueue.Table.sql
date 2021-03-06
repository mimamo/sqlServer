USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectRollupQueue]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tProjectRollupQueue](
	[ProjectKey] [int] NOT NULL,
	[DateRequested] [smalldatetime] NOT NULL,
	[DateUpdated] [smalldatetime] NULL,
	[Updated] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tProjectRollupQueue] ADD  CONSTRAINT [DF_Table_1_DateEntered]  DEFAULT (getdate()) FOR [DateRequested]
GO
ALTER TABLE [dbo].[tProjectRollupQueue] ADD  CONSTRAINT [DF_tProjectRollupQueue_Processed]  DEFAULT ((0)) FOR [Updated]
GO
