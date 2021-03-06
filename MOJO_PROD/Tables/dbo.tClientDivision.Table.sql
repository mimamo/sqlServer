USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tClientDivision]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tClientDivision](
	[ClientDivisionKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[DivisionName] [varchar](300) NOT NULL,
	[Active] [tinyint] NULL,
	[ProjectNumPrefix] [varchar](20) NULL,
	[NextProjectNum] [int] NULL,
	[LinkID] [varchar](100) NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[DivisionID] [varchar](50) NULL,
 CONSTRAINT [PK_tClientDivision] PRIMARY KEY CLUSTERED 
(
	[ClientDivisionKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tClientDivision]  WITH CHECK ADD  CONSTRAINT [FK_tClientDivision_tCompany] FOREIGN KEY([ClientKey])
REFERENCES [dbo].[tCompany] ([CompanyKey])
GO
ALTER TABLE [dbo].[tClientDivision] CHECK CONSTRAINT [FK_tClientDivision_tCompany]
GO
ALTER TABLE [dbo].[tClientDivision] ADD  CONSTRAINT [DF_tClientDivision_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
