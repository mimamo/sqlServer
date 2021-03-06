USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tDepartment]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tDepartment](
	[DepartmentKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[DepartmentName] [varchar](200) NOT NULL,
	[Active] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tDepartment] PRIMARY KEY NONCLUSTERED 
(
	[DepartmentKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tDepartment] ADD  CONSTRAINT [DF_tDepartment_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
