USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_PerEnt_PerPost]    Script Date: 12/21/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_PerEnt_PerPost    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_PerEnt_PerPost] @parm1 varchar ( 6), @parm2 varchar ( 6) As
        Select * from ARTran
        where (PerPost = @parm1
        or PerEnt = @parm2)
        and Rlsed = 1
        order by TranDate Desc
GO
