USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Update_ARTran_ARAdjust0]    Script Date: 12/21/2015 13:45:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Update_ARTran_ARAdjust0    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[Update_ARTran_ARAdjust0] @parm1 smalldatetime, @parm2 varchar ( 15), @parm3 varchar ( 2), @parm4 varchar ( 10) as
    UPDATE ARTran
    SET ARTran.TranDate = @parm1
        WHERE ARTran.Custid = @parm2
        AND ARTran.TranType = @Parm3
        AND ARTran.Refnbr = @parm4
GO
