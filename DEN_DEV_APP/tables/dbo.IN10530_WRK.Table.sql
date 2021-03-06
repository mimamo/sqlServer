USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[IN10530_WRK]    Script Date: 12/21/2015 14:05:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10530_WRK](
	[ClassID] [char](6) NOT NULL,
	[ComputerName] [char](21) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IN10530_WRK] ADD  CONSTRAINT [DF_IN10530_WRK_ClassID]  DEFAULT (' ') FOR [ClassID]
GO
ALTER TABLE [dbo].[IN10530_WRK] ADD  CONSTRAINT [DF_IN10530_WRK_ComputerName]  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[IN10530_WRK] ADD  CONSTRAINT [DF_IN10530_WRK_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10530_WRK] ADD  CONSTRAINT [DF_IN10530_WRK_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
