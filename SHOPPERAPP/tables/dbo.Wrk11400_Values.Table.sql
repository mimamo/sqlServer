USE [SHOPPERAPP]
GO
/****** Object:  Table [dbo].[Wrk11400_Values]    Script Date: 12/21/2015 16:12:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Wrk11400_Values](
	[BaseCury] [smallint] NOT NULL,
	[BMICury] [smallint] NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Inv_Unit_Price] [smallint] NOT NULL,
	[Inv_Unit_Qty] [smallint] NOT NULL,
	[UserAddress] [char](21) NOT NULL,
	[WrkMoney] [smallint] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Wrk11400_Values] ADD  DEFAULT ((0)) FOR [BaseCury]
GO
ALTER TABLE [dbo].[Wrk11400_Values] ADD  DEFAULT ((0)) FOR [BMICury]
GO
ALTER TABLE [dbo].[Wrk11400_Values] ADD  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),(0)),(0)))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[Wrk11400_Values] ADD  DEFAULT ((0)) FOR [Inv_Unit_Price]
GO
ALTER TABLE [dbo].[Wrk11400_Values] ADD  DEFAULT ((0)) FOR [Inv_Unit_Qty]
GO
ALTER TABLE [dbo].[Wrk11400_Values] ADD  DEFAULT (' ') FOR [UserAddress]
GO
ALTER TABLE [dbo].[Wrk11400_Values] ADD  DEFAULT ((0)) FOR [WrkMoney]
GO
