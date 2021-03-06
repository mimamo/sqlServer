USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AllocGrp_GrpId_PerNbr]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllocGrp_GrpId_PerNbr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AllocGrp_GrpId_PerNbr] @parm1 varchar(10), @parm2 varchar(10), @parm3 varchar(6), @parm4 varchar(6) as
       Select * from AllocGrp
           where LedgerID like @parm1
             and CpnyId like @parm2
             and GrpId like    @parm3
             and ((StartPeriod <= @parm4
             and EndPeriod >= @parm4)
             or (StartPeriod = ""
             and EndPeriod = ""))
                 and Status = 1
           order by TranLedgerId, CpnyId, GrpId
GO
