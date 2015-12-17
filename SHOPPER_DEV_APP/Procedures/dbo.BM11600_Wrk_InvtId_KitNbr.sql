USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BM11600_Wrk_InvtId_KitNbr]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BM11600_Wrk_InvtId_KitNbr] @parm1 varchar ( 30), @parm2  integer  as
            Select * from BM11600_Wrk where InvtId = @parm1 And KitNbr = @parm2
           Order by InvtId, KitNbr
GO
