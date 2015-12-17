USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTxnType_Check_Settle_Date]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTxnType_Check_Settle_Date]
AS

	SELECT	T.*
	FROM	XDDTxnType T (nolock) LEFT OUTER JOIN XDDFileFormat F (nolock)
		ON T.FormatID = F.FormatID
	WHERE	F.Selected = 'Y'
		and T.Selected = 'Y'
		and T.ChkWF = 'M'
		and T.ChkWF_CreateMCB = 'S'	-- Settlement Date batches
GO
