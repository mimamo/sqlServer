USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_SID_LocAvail_Qty]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LocTable_SID_LocAvail_Qty] @parm1 varchar (10), @parm2 varchar (30), @parm3 varchar (30), @parm4 varchar (30),@parm5 varchar (10) as
select location.* from loctable LT,location where LT.siteid = @parm1
and LT.SalesValid <> 'N' and ((LT.InvtIDValid = 'Y' and LT.InvtID = @parm2 and Location.invtid = @parm3)
or (LT.InvtIDValid <> 'Y' and Location.invtid = @parm4)) and LT.whseloc like @parm5
and LT.siteid = Location.siteid and LT.whseloc = Location.whseloc
Order by LT.WhseLoc
GO
