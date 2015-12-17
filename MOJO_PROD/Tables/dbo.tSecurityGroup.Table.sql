USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tSecurityGroup]    Script Date: 12/11/2015 15:29:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tSecurityGroup](
	[SecurityGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](100) NOT NULL,
	[CompanyKey] [int] NULL,
	[Active] [tinyint] NULL,
	[StandardDesktop] [text] NULL,
	[ChangeLayout] [tinyint] NULL,
	[ChangeDesktop] [tinyint] NULL,
	[ChangeWindow] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[SecurityLevel] [smallint] NULL,
	[DefaultActionID] [varchar](300) NULL,
 CONSTRAINT [tSecurityGroup_PK] PRIMARY KEY CLUSTERED 
(
	[SecurityGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tSecurityGroup]  WITH CHECK ADD  CONSTRAINT [tCompany_tSecurityGroup_FK1] FOREIGN KEY([CompanyKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tSecurityGroup] CHECK CONSTRAINT [tCompany_tSecurityGroup_FK1]
GO
ALTER TABLE [dbo].[tSecurityGroup] ADD  CONSTRAINT [DF_tSecurityGroup_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[tSecurityGroup] ADD  CONSTRAINT [DF_tSecurityGroup_SecurityLevel]  DEFAULT ((1)) FOR [SecurityLevel]
GO
