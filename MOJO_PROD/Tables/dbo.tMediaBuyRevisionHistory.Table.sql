USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaBuyRevisionHistory]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaBuyRevisionHistory](
	[CompanyKey] [int] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[EntityKey] [int] NOT NULL,
	[Action] [varchar](200) NOT NULL,
	[ActionDate] [datetime] NOT NULL,
	[UserKey] [int] NOT NULL,
	[FieldName] [varchar](200) NULL,
	[FieldType] [smallint] NULL,
	[OldString] [varchar](500) NULL,
	[OldDecimal] [decimal](24, 4) NULL,
	[OldInt] [int] NULL,
	[OldMoney] [money] NULL,
	[OldDate] [smalldatetime] NULL,
	[NewString] [varchar](500) NULL,
	[NewDecimal] [decimal](24, 4) NULL,
	[NewInt] [int] NULL,
	[NewMoney] [money] NULL,
	[NewDate] [smalldatetime] NULL,
	[Comments] [varchar](200) NULL,
	[Revision] [int] NOT NULL,
	[MediaPremiumKey] [int] NULL,
	[POKind] [smallint] NULL,
	[LineNumber] [int] NULL,
	[PremiumID] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaBuyRevisionHistory] ADD  CONSTRAINT [DF_tMediaBuyRevisionHistory_ActionDate]  DEFAULT (getutcdate()) FOR [ActionDate]
GO
ALTER TABLE [dbo].[tMediaBuyRevisionHistory] ADD  CONSTRAINT [DF_tMediaBuyRevisionHistory_POKind]  DEFAULT ((1)) FOR [POKind]
GO
