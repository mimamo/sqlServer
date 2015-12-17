USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DDAchHeadTrail_HT_StartPos]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDAchHeadTrail_HT_StartPos] @parm1 varchar ( 1), @parm2 varchar ( 2) as
    Select * from DDAchHeadTrail where Header_Trailer LIKE @parm1 and StartPos LIKE @Parm2 ORDER by Header_Trailer, StartPos
GO
