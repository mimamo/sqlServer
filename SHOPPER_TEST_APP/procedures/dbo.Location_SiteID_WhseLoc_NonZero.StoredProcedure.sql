USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_SiteID_WhseLoc_NonZero]    Script Date: 12/21/2015 16:07:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Location_SiteID_WhseLoc_NonZero] @parm1 varchar(10), @parm2 varchar(10) as
select * from Location
where 	SiteID = @parm1 and
	WhseLoc = @parm2 and (
	abs(QtyAlloc) >= 0.0000000005 or
	abs(QtyOnHand) >= 0.0000000005 or
	abs(QtyShipNotInv) >= 0.0000000005 or
	abs(QtyWORlsedDemand) >= 0.0000000005)
GO
