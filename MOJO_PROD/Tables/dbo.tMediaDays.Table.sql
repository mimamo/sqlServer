USE [MOJo_prod]
GO
/****** Object:  Table [dbo].[tMediaDays]    Script Date: 12/11/2015 15:29:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tMediaDays](
	[MediaDayKey] [int] IDENTITY(1,1) NOT NULL,
	[CompanyKey] [int] NOT NULL,
	[Days] [varchar](50) NOT NULL,
	[Description] [varchar](1000) NULL,
	[Monday] [tinyint] NOT NULL,
	[Tuesday] [tinyint] NOT NULL,
	[Wednesday] [tinyint] NOT NULL,
	[Thursday] [tinyint] NOT NULL,
	[Friday] [tinyint] NOT NULL,
	[Saturday] [tinyint] NOT NULL,
	[Sunday] [tinyint] NOT NULL,
	[Active] [tinyint] NOT NULL,
 CONSTRAINT [PK_tMediaDays] PRIMARY KEY CLUSTERED 
(
	[MediaDayKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tMediaDays] ADD  CONSTRAINT [DF_tMediaDays_Monday]  DEFAULT ((0)) FOR [Monday]
GO
ALTER TABLE [dbo].[tMediaDays] ADD  CONSTRAINT [DF_tMediaDays_Tuesday]  DEFAULT ((0)) FOR [Tuesday]
GO
ALTER TABLE [dbo].[tMediaDays] ADD  CONSTRAINT [DF_tMediaDays_Wenesday]  DEFAULT ((0)) FOR [Wednesday]
GO
ALTER TABLE [dbo].[tMediaDays] ADD  CONSTRAINT [DF_tMediaDays_Thursday]  DEFAULT ((0)) FOR [Thursday]
GO
ALTER TABLE [dbo].[tMediaDays] ADD  CONSTRAINT [DF_tMediaDays_Friday]  DEFAULT ((0)) FOR [Friday]
GO
ALTER TABLE [dbo].[tMediaDays] ADD  CONSTRAINT [DF_tMediaDays_Saturday]  DEFAULT ((0)) FOR [Saturday]
GO
ALTER TABLE [dbo].[tMediaDays] ADD  CONSTRAINT [DF_tMediaDays_Sunday]  DEFAULT ((0)) FOR [Sunday]
GO
ALTER TABLE [dbo].[tMediaDays] ADD  CONSTRAINT [DF_tMediaDays_Active]  DEFAULT ((1)) FOR [Active]
GO
