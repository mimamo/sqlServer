USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AllocGrp_GrpId_PerNbr_Seq]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[AllocGrp_GrpId_PerNbr_Seq] @parm1 varchar(10), @parm2 varchar(10), @parm3 varchar(6), @parm4 varchar(6) as
       Select * from AllocGrp
           where LedgerID like @parm1
             and CpnyId like @parm2
             and GrpId like    @parm3
	     and PoolSequence <> 0
             and ((StartPeriod <= @parm4
             and EndPeriod >= @parm4)
             or (StartPeriod = ' '
             and EndPeriod = ' '))
                 and Status = 1
           order by Poolsequence, GrpId
GO
