USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[PJREVHDR]    Script Date: 12/21/2015 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PJREVHDR](
	[approved_by1] [char](10) NOT NULL,
	[approved_by2] [char](10) NOT NULL,
	[approved_by3] [char](10) NOT NULL,
	[approver] [char](10) NOT NULL,
	[Change_Order_Num] [char](16) NOT NULL,
	[Create_Date] [smalldatetime] NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crtd_prog] [char](8) NOT NULL,
	[crtd_user] [char](10) NOT NULL,
	[end_date] [smalldatetime] NOT NULL,
	[Est_Approve_Date] [smalldatetime] NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_prog] [char](8) NOT NULL,
	[lupd_user] [char](10) NOT NULL,
	[NoteId] [int] NOT NULL,
	[Post_Date] [smalldatetime] NOT NULL,
	[Post_Period] [char](6) NOT NULL,
	[Preparer] [char](10) NOT NULL,
	[Project] [char](16) NOT NULL,
	[RevId] [char](4) NOT NULL,
	[RevisionType] [char](2) NOT NULL,
	[Revision_Desc] [char](60) NOT NULL,
	[rh_id01] [char](30) NOT NULL,
	[rh_id02] [char](30) NOT NULL,
	[rh_id03] [char](16) NOT NULL,
	[rh_id04] [char](16) NOT NULL,
	[rh_id05] [char](4) NOT NULL,
	[rh_id06] [float] NOT NULL,
	[rh_id07] [float] NOT NULL,
	[rh_id08] [smalldatetime] NOT NULL,
	[rh_id09] [smalldatetime] NOT NULL,
	[rh_id10] [smallint] NOT NULL,
	[start_date] [smalldatetime] NOT NULL,
	[status] [char](2) NOT NULL,
	[update_type] [char](1) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [pjrevhdr0] PRIMARY KEY CLUSTERED 
(
	[Project] ASC,
	[RevId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
