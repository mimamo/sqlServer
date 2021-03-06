USE [NEWYORKAPP]
GO
/****** Object:  Table [dbo].[SIDepartment]    Script Date: 12/21/2015 16:00:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SIDepartment](
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_Prog] [char](8) NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[DeptID] [char](10) NOT NULL,
	[Description] [char](30) NOT NULL,
	[DfltDelivAddr1] [char](30) NOT NULL,
	[DfltDelivAddr2] [char](30) NOT NULL,
	[DfltDelivAttn] [char](30) NOT NULL,
	[DfltDelivCity] [char](30) NOT NULL,
	[DfltDelivCountry] [char](3) NOT NULL,
	[DfltDelivEmail] [char](30) NOT NULL,
	[DfltDelivFax] [char](30) NOT NULL,
	[DfltDelivName] [char](30) NOT NULL,
	[DfltDelivPhone] [char](30) NOT NULL,
	[DfltDelivState] [char](3) NOT NULL,
	[DfltDelivZip] [char](10) NOT NULL,
	[DfltExpAcct] [char](10) NOT NULL,
	[DfltExpSub] [char](24) NOT NULL,
	[LUpd_DateTime] [smalldatetime] NOT NULL,
	[LUpd_Prog] [char](8) NOT NULL,
	[LUpd_User] [char](10) NOT NULL,
	[NoteID] [int] NOT NULL,
	[S4Future01] [char](30) NOT NULL,
	[S4Future02] [char](30) NOT NULL,
	[S4Future03] [float] NOT NULL,
	[S4Future04] [float] NOT NULL,
	[S4Future05] [float] NOT NULL,
	[S4Future06] [float] NOT NULL,
	[S4Future07] [smalldatetime] NOT NULL,
	[S4Future08] [smalldatetime] NOT NULL,
	[S4Future09] [int] NOT NULL,
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
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [SIDepartment0] PRIMARY KEY NONCLUSTERED 
(
	[DeptID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
