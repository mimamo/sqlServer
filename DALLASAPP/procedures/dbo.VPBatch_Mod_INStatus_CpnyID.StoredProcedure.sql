USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[VPBatch_Mod_INStatus_CpnyID]    Script Date: 12/21/2015 13:45:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[VPBatch_Mod_INStatus_CpnyID] @parm1 varchar ( 10) as
       Select * from Batch
           where Module   IN ('PR','VP')
             and CpnyId Like  @parm1
             and Status   IN ('B', 'S', 'I')
             and EditScrnNbr  = '58010'
           order by Module, BatNbr
GO
