USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tProjectType]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tProjectType](
	[ProjectTypeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ProjectTypeName] [varchar](100) NULL,
	[Description] [varchar](500) NULL,
	[Subject1] [varchar](200) NULL,
	[Subject2] [varchar](200) NULL,
	[Subject3] [varchar](200) NULL,
	[Subject4] [varchar](200) NULL,
	[Subject5] [varchar](200) NULL,
	[Subject6] [varchar](200) NULL,
	[Subject7] [varchar](200) NULL,
	[Subject8] [varchar](200) NULL,
	[Subject9] [varchar](200) NULL,
	[Subject10] [varchar](200) NULL,
	[Subject11] [varchar](200) NULL,
	[Subject12] [varchar](200) NULL,
	[ProjectNumPrefix] [varchar](20) NULL,
	[NextProjectNum] [int] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[Active] [tinyint] NULL,
 CONSTRAINT [PK_tProjectType] PRIMARY KEY NONCLUSTERED 
(
	[ProjectTypeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tProjectType] ADD  CONSTRAINT [DF_tProjectType_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tProjectType] ADD  CONSTRAINT [DF_tProjectType_Active]  DEFAULT ((1)) FOR [Active]
GO
