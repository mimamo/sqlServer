USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tStandardActivity]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tStandardActivity](
	[StandardActivityKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[LeadStageKey] [int] NULL,
	[Level] [smallint] NULL,
	[ProjectTypeKey] [int] NULL,
	[Type] [varchar](50) NULL,
	[Priority] [varchar](20) NULL,
	[Subject] [varchar](2000) NOT NULL,
	[DaysToWait] [int] NOT NULL,
	[Notes] [text] NULL,
	[Required] [tinyint] NULL,
 CONSTRAINT [PK_tStandardActivity] PRIMARY KEY CLUSTERED 
(
	[StandardActivityKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tStandardActivity] ADD  CONSTRAINT [DF_tStandardActivity_Priority]  DEFAULT ('2-Medium') FOR [Priority]
GO
