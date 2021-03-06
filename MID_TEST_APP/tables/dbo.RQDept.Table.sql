USE [MID_TEST_APP]
GO
/****** Object:  Table [dbo].[RQDept]    Script Date: 12/21/2015 14:26:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RQDept](
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[DeptID] [char](10) NOT NULL,
	[Description] [char](30) NOT NULL,
	[DfltDelivAddr1] [char](60) NOT NULL,
	[DfltDelivAddr2] [char](60) NOT NULL,
	[DfltDelivAttn] [char](30) NOT NULL,
	[DfltDelivCity] [char](30) NOT NULL,
	[DfltDelivCountry] [char](3) NOT NULL,
	[DfltDelivEmail] [char](80) NOT NULL,
	[DfltDelivFax] [char](30) NOT NULL,
	[DfltDelivName] [char](60) NOT NULL,
	[DfltDelivPhone] [char](30) NOT NULL,
	[DfltDelivState] [char](3) NOT NULL,
	[DfltDelivZip] [char](10) NOT NULL,
	[DfltExpAcct] [char](10) NOT NULL,
	[DfltExpSub] [char](24) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[S4Future1] [char](30) NOT NULL,
	[S4Future2] [char](30) NOT NULL,
	[S4Future3] [float] NOT NULL,
	[S4Future4] [float] NOT NULL,
	[S4Future5] [float] NOT NULL,
	[S4Future6] [float] NOT NULL,
	[S4Future7] [smalldatetime] NOT NULL,
	[S4Future8] [smalldatetime] NOT NULL,
	[S4Future9] [int] NOT NULL,
	[S4Future10] [int] NOT NULL,
	[S4Future11] [char](10) NOT NULL,
	[S4Future12] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[UserID] [char](47) NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
