USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_EditScrnNbr_2_CpnyID]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--- DCR Added for 32bit 4/7/98
Create Proc [dbo].[Batch_EditScrnNbr_2_CpnyID] @parm1 varchar ( 10), @parm2 varchar ( 5), @parm3 varchar ( 5), @parm4 varchar ( 010) as
       Select * from Batch where
        CpnyID = @parm1
        and (EditScrnNbr = @parm2 or EditScrnNbr = @parm3)
        and BatNbr like @parm4
        order by BatNbr
GO
