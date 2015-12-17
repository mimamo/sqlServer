USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tLeadOutcome]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tLeadOutcome](
	[LeadOutcomeKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Outcome] [varchar](200) NOT NULL,
	[LastModified] [smalldatetime] NOT NULL,
	[PositiveOutcome] [tinyint] NULL,
 CONSTRAINT [PK_tLeadOutcome] PRIMARY KEY NONCLUSTERED 
(
	[LeadOutcomeKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tLeadOutcome] ADD  CONSTRAINT [DF_tLeadOutcome_LastModified]  DEFAULT (getutcdate()) FOR [LastModified]
GO
