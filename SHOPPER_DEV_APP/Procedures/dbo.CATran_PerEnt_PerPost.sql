USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_PerEnt_PerPost]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_PerEnt_PerPost    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[CATran_PerEnt_PerPost] @parm1 varchar ( 6), @parm2 varchar ( 6) As
        Select * from CATran
        where (PerPost = @parm1
        or PerEnt = @parm2)
        and Rlsed =  1
        order by Perent
GO
