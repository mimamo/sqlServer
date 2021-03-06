USE [MIDWESTAPP]
GO
/****** Object:  Table [dbo].[xRetailCustomer]    Script Date: 12/21/2015 15:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xRetailCustomer](
	[RID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RCustId] [char](5) NOT NULL,
	[RCustName] [char](30) NOT NULL,
	[RCustParent] [char](50) NULL,
	[Status] [char](1) NOT NULL,
	[crtd_datetime] [smalldatetime] NOT NULL,
	[crdt_user] [char](10) NOT NULL,
	[lupd_datetime] [smalldatetime] NOT NULL,
	[lupd_user] [char](10) NOT NULL,
 CONSTRAINT [PK_xRetailCustomer] PRIMARY KEY CLUSTERED 
(
	[RID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
