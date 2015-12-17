USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Warehouse_Location_DBNAV]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Warehouse_Location_DBNAV]
   @Parm1 Char(30),
   @Parm2 Char(10),
   @Parm3 Char(10)
as
Select * from Location
   Where InvtID like @Parm1
     and SiteID Like @Parm2
     and WhseLoc Like @Parm3
   Order By InvtId, SiteId, WhseLoc
GO
