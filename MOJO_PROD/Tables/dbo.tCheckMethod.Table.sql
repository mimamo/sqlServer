USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tCheckMethod]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tCheckMethod](
	[CheckMethodKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[CheckMethod] [varchar](100) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tCheckMethod] PRIMARY KEY CLUSTERED 
(
	[CheckMethodKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tCheckMethod] ADD  CONSTRAINT [DF_tCheckMethod_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tCheckMethod] ADD  CONSTRAINT [DF_tCheckMethod_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
