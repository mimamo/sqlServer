USE [DENVERAPP]
GO
/****** Object:  Table [dbo].[IN10520_WRK]    Script Date: 12/21/2015 15:42:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IN10520_WRK](
	[ClassID] [char](6) NOT NULL,
	[ComputerName] [char](21) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[InvtID] [char](30) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[IN10520_WRK] ADD  CONSTRAINT [DF_IN10520_WRK_ClassID]  DEFAULT (' ') FOR [ClassID]
GO
ALTER TABLE [dbo].[IN10520_WRK] ADD  CONSTRAINT [DF_IN10520_WRK_ComputerName]  DEFAULT (' ') FOR [ComputerName]
GO
ALTER TABLE [dbo].[IN10520_WRK] ADD  CONSTRAINT [DF_IN10520_WRK_Crtd_DateTime]  DEFAULT (rtrim(CONVERT([varchar](30),CONVERT([smalldatetime],getdate(),0),0))) FOR [Crtd_DateTime]
GO
ALTER TABLE [dbo].[IN10520_WRK] ADD  CONSTRAINT [DF_IN10520_WRK_InvtID]  DEFAULT (' ') FOR [InvtID]
GO
