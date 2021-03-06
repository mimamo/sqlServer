USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POTran_RcptNbr]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POTran_RcptNbr    Script Date: 4/16/98 7:50:26 PM ******/
Create proc [dbo].[POTran_RcptNbr] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
        Select * from POTran where RcptNbr = @parm1
            and LineNbr between @parm2beg and @parm2end
            Order by RcptNbr, LineNbr
GO
