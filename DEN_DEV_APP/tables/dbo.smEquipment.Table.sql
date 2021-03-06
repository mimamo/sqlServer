USE [DEN_DEV_APP]
GO
/****** Object:  Table [dbo].[smEquipment]    Script Date: 12/21/2015 14:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[smEquipment](
	[Crdt_Prog] [char](8) NOT NULL,
	[Crtd_DateTime] [smalldatetime] NOT NULL,
	[Crtd_User] [char](10) NOT NULL,
	[EquipLocationType] [char](1) NOT NULL,
	[EquipmentCondDate] [smalldatetime] NOT NULL,
	[EquipmentCondition] [char](1) NOT NULL,
	[EquipmentDesc] [char](30) NOT NULL,
	[EquipmentEmployeeID] [char](10) NOT NULL,
	[EquipmentID] [char](10) NOT NULL,
	[EquipmentMake] [char](16) NOT NULL,
	[EquipmentModel] [char](16) NOT NULL,
	[EquipmentPurDate] [smalldatetime] NOT NULL,
	[EquipmentSiteID] [char](10) NOT NULL,
	[EquipmentUsageID] [char](10) NOT NULL,
	[EquipmentVIN] [char](16) NOT NULL,
	[EquipmentYear] [char](4) NOT NULL,
	[Lupd_DateTime] [smalldatetime] NOT NULL,
	[Lupd_Prog] [char](8) NOT NULL,
	[Lupd_User] [char](10) NOT NULL,
	[User1] [char](30) NOT NULL,
	[User2] [char](30) NOT NULL,
	[User3] [float] NOT NULL,
	[User4] [float] NOT NULL,
	[User5] [char](10) NOT NULL,
	[User6] [char](10) NOT NULL,
	[User7] [smalldatetime] NOT NULL,
	[User8] [smalldatetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
