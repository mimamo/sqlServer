USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_Site_IncQtyAvail]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[LotSerMst_Site_IncQtyAvail]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@WhseLoc	VARCHAR (10)
As
	SELECT W.INCLQTYAVAIL
		FROM LOTSERMST L
			JOIN LOCTABLE W
				ON L.SITEID = W.SITEID
				AND L.WHSELOC = W.WHSELOC
		WHERE L.SITEID = @SiteID
			AND L.WHSELOC = @WhseLoc
			AND L.INVTID = @InvtID
GO
