USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[APAdjust_AdjgRefNbr]    Script Date: 12/21/2015 16:00:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APAdjust_AdjgRefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APAdjust_AdjgRefNbr] @parm1 varchar ( 10), @parm2 varchar ( 2), @parm3 varchar ( 10), @parm4 varchar ( 24) As
Select * from APAdjust Where
AdjgRefNbr = @parm1 and
AdjgDocType = @parm2 and
AdjgAcct = @parm3 and
AdjgSub = @parm4
GO
