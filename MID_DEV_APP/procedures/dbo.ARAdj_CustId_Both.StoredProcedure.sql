USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdj_CustId_Both]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ARAdj_CustId_Both] @parm1 varchar ( 15), @parm2 varchar ( 2), @parm3 varchar ( 10),
@parm4 varchar ( 2), @parm5 varchar ( 10) as

    Select * from ARAdjust where CustId = @parm1
           and AdjgDocType = @parm2
           and AdjgRefNbr = @parm3
	   and AdjdDoctype = @parm4
	   and AdjdRefnbr = @parm5
           order by CustId, AdjgDocType,AdjgRefNbr
GO
