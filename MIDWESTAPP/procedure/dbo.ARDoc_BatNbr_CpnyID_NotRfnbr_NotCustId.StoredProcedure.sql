USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_BatNbr_CpnyID_NotRfnbr_NotCustId]    Script Date: 12/21/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ARDoc_BatNbr_CpnyID_NotRfnbr_NotCustId] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 10), @parm4 varchar ( 15) as
    Select CuryOrigDocAmt from ARDoc where
        BatNbr = @parm1 and
        CpnyID=@parm2  and
        not (refnbr=@parm3 and custid=@parm4)
GO
