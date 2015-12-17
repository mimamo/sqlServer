USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDPmtSelectionFilter_Get_WorkFlow]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDPmtSelectionFilter_Get_WorkFlow]
   @AccessNbr	smallint,
   @EBGroup	varchar( 2 )

AS
  
   SELECT	T.ChkWF,
   		T.ChkWF_CreateMCB
   FROM		XDDWrkCheckSel W (nolock) LEFT OUTER JOIN XDDTxnType T (nolock)
		ON W.EBFormatID = T.FormatID and W.EBEStatus = T.EStatus
   WHERE	W.AccessNbr = @AccessNbr
   		and W.EBGroup = @EBGroup
GO
