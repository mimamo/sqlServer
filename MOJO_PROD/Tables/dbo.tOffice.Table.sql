USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tOffice]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tOffice](
	[OfficeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[OfficeName] [varchar](200) NOT NULL,
	[ProjectNumPrefix] [varchar](20) NULL,
	[NextProjectNum] [int] NULL,
	[Active] [tinyint] NULL,
	[AddressKey] [int] NULL,
	[OfficeID] [varchar](50) NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[WebDavServerKey] [int] NULL,
 CONSTRAINT [PK_tOffice] PRIMARY KEY NONCLUSTERED 
(
	[OfficeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tOffice] ADD  CONSTRAINT [DF_tOffice_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
