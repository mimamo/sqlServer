USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_PerEnt_PerPost]    Script Date: 12/21/2015 13:44:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_PerEnt_PerPost    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTran_PerEnt_PerPost] @parm1 varchar ( 6), @parm2 varchar ( 6) As
        Select * from APTran
        where (PerPost = @parm1
        or PerEnt = @parm2)
        and Rlsed = 1
        order by RefNbr, Trantype, LineNbr
GO
