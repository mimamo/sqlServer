USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRBatch_Mod_INStatus_CpnyID]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRBatch_Mod_INStatus_CpnyID] @parm1 varchar ( 2), @parm2 varchar ( 10) as
       Select * from Batch
           where Module   =   @parm1
             and CpnyId Like  @parm2
             and Status   IN ('B', 'S', 'I')
             and EditScrnNbr  <> '58010'
           order by Module, BatNbr
GO
