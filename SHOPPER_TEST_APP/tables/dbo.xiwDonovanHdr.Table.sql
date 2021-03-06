USE [SHOPPER_TEST_APP]
GO
/****** Object:  Table [dbo].[xiwDonovanHdr]    Script Date: 12/21/2015 16:06:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xiwDonovanHdr](
	[DonovanHdrKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[APBatNbr] [char](10) NULL,
	[APBatTot] [float] NULL,
	[Crtd_DateTime] [smalldatetime] NULL,
	[Crtd_User] [char](50) NULL,
 CONSTRAINT [xiwDonovanHdr0] PRIMARY KEY CLUSTERED 
(
	[DonovanHdrKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
