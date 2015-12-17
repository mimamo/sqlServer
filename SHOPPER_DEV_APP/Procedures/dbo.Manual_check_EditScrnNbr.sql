USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Manual_check_EditScrnNbr]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Manual_check_EditScrnNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select * from Batch
           where (EditScrnNbr = '02040' OR EditScrnNbr = '02630' OR EditScrnNbr = '02635')
             and module = 'PR'
             and CpnyId like @parm1
             and BatNbr like @parm2
             and Status <> 'K'
             and Status <> 'R'
             order by BatNbr
GO
