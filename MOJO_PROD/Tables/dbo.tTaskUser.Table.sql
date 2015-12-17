USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tTaskUser]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTaskUser](
	[UserKey] [int] NULL,
	[TaskKey] [int] NOT NULL,
	[Hours] [decimal](24, 4) NULL,
	[PercComp] [int] NULL,
	[ActStart] [smalldatetime] NULL,
	[ActComplete] [smalldatetime] NULL,
	[ReviewedByTraffic] [tinyint] NULL,
	[ReviewedByDate] [smalldatetime] NULL,
	[ReviewedByKey] [int] NULL,
	[CompletedByDate] [datetime] NULL,
	[CompletedByKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[TaskUserKey] [int] IDENTITY(1,1) NOT NULL,
	[Subject] [varchar](500) NULL,
	[Description] [text] NULL,
	[Comments] [varchar](4000) NULL,
	[DeliverableKey] [int] NULL,
	[APlanStart] [smalldatetime] NULL,
	[APlanComplete] [smalldatetime] NULL,
	[APredecessorsComplete] [tinyint] NULL,
 CONSTRAINT [PK_tTaskUser_1] PRIMARY KEY CLUSTERED 
(
	[TaskUserKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
