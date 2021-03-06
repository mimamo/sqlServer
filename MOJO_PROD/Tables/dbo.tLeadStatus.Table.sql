USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLeadStatus]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLeadStatus](
	[LeadStatusKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[LeadStatusName] [varchar](200) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[Active] [tinyint] NULL,
	[LastModified] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tLeadStatus] PRIMARY KEY NONCLUSTERED 
(
	[LeadStatusKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tLeadStatus] ADD  CONSTRAINT [DF_tLeadStatus_DisplayOrder]  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[tLeadStatus] ADD  CONSTRAINT [DF_tLeadStatus_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[tLeadStatus] ADD  CONSTRAINT [DF_tLeadStatus_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
