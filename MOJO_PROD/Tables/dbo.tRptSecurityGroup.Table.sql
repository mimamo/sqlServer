USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tRptSecurityGroup]    Script Date: 12/21/2015 16:17:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRptSecurityGroup](
	[RptSecurityGroupKey] [int] IDENTITY(1,1) NOT NULL,
	[ReportKey] [int] NULL,
	[SecurityGroupKey] [int] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tRptSecurityGroup] PRIMARY KEY NONCLUSTERED 
(
	[RptSecurityGroupKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tRptSecurityGroup]  WITH CHECK ADD  CONSTRAINT [FK_tRptSecurityGroup_tSecurityGroup] FOREIGN KEY([SecurityGroupKey])
REFERENCES [dbo].[tSecurityGroup] ([SecurityGroupKey])
GO
ALTER TABLE [dbo].[tRptSecurityGroup] CHECK CONSTRAINT [FK_tRptSecurityGroup_tSecurityGroup]
GO
ALTER TABLE [dbo].[tRptSecurityGroup] ADD  CONSTRAINT [DF_tRptSecurityGroup_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
