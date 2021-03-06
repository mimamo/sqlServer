USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WORequest_Count_InvtID]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WORequest_Count_InvtID]
   @InvtID   	varchar( 30 )

AS
	-- If there is a wild card in @InvtID
	-- use LIKE; otherwise use =
	IF PATINDEX('%[%]%', @InvtID) > 0
		SELECT	COUNT(L.OrdNbr)
		FROM	WORequest W WITH (NOLOCK)

		JOIN	SOLine L WITH (NOLOCK)
		  ON	L.CpnyID = W.CpnyID
		 AND	L.OrdNbr = W.OrdNbr
		 AND	L.LineRef = W.LineRef

		WHERE	L.InvtID + '' LIKE @InvtID
		  AND	L.Status = 'O'
	ELSE
		SELECT	COUNT(L.OrdNbr)
		FROM	WORequest W WITH (NOLOCK)

		JOIN	SOLine L WITH (NOLOCK)
		  ON	L.CpnyID = W.CpnyID
		 AND	L.OrdNbr = W.OrdNbr
		 AND	L.LineRef = W.LineRef

		WHERE	L.InvtID = @InvtID
		  AND	L.Status = 'O'
GO
