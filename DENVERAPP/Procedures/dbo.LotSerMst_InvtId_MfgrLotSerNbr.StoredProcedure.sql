USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_InvtId_MfgrLotSerNbr]    Script Date: 12/21/2015 15:42:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.LotSerMst_InvtId_MfgrLotSerNbr                           ******/
Create Proc [dbo].[LotSerMst_InvtId_MfgrLotSerNbr] @parm1 varchar ( 30), @parm2 varchar (25), @parm3 varchar (10), @parm4 varchar (10) as
    Select * from LotSerMst where InvtId = @parm1
                  and MfgrLotSerNbr = @parm2
                  and SiteId = @parm3
                  and WhseLoc = @parm4
                  order by InvtId, MfgrLotSerNbr
GO
