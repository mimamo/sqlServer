USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APAdjust_APDoc_AdjgRefNbr_]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APAdjust_APDoc_AdjgRefNbr_] @parm1 varchar ( 10), @parm2 varchar ( 2), @parm3 varchar ( 10), @parm4 varchar ( 24) as
Select *
from APAdjust
	left outer join APDoc
		on APAdjust.AdjdRefNbr = APDoc.RefNbr
			and APAdjust.AdjdDocType = APDoc.DocType
where APAdjust.AdjgRefNbr = @parm1
and APAdjust.AdjgDocType = @parm2
and APAdjust.AdjgAcct = @parm3
and APAdjust.AdjgSub = @parm4
Order By APAdjust.AdjdRefNbr, APAdjust.AdjdDocType, APAdjust.VendId
GO
