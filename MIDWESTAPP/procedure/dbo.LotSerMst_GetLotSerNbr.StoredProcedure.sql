USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_GetLotSerNbr]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[LotSerMst_GetLotSerNbr]
 	@parm1 varchar ( 30),
        @parm2 varchar (25),
        @parm3 varchar (10),
        @parm4 varchar (15)
as
    Select * from LotSerMst where InvtId = @Parm1
                  and LotSerNbr = @Parm2
                  and Siteid Like @Parm3
                  and WhseLoc Like @Parm4
                  order by InvtId, LotSerNbr, Siteid, Whseloc
GO
