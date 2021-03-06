USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaPremium]    Script Date: 12/21/2015 16:17:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaPremium](
	[MediaPremiumKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[POKind] [smallint] NOT NULL,
	[ItemKey] [int] NOT NULL,
	[PremiumName] [varchar](300) NOT NULL,
	[PremiumID] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
	[Active] [tinyint] NOT NULL,
	[PremiumShortName] [varchar](100) NULL,
 CONSTRAINT [PK_tMediaPremium] PRIMARY KEY CLUSTERED 
(
	[MediaPremiumKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
