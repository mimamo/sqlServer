USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CuryAcct_All_2]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[CuryAcct_All_2] @parm1 varchar(10), @parm2 varchar (10), @parm3 varchar (24), @parm4 varchar (24), @parm5 varchar (4), @parm6 varchar (4) as
       Select * from CuryAcct
           where CpnyID = @parm1
             and Acct   = @parm2
             and Sub    = @parm3
             and LedgerID = @parm4
             and FiscYr = @parm5
             and CuryID = @parm6
             order by CpnyID, Acct,Sub,LedgerID, FiscYr, CuryID
GO
