USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Itemsite_PILastCountDate]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Itemsite_PILastCountDate    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[Itemsite_PILastCountDate] @parm1 varchar(10), @parm2 smalldatetime, @parm3 smallint as
	SELECT s.*
	FROM ItemSite s JOIN Inventory i ON i.InvtID = s.InvtID
	WHERE s.siteid = @Parm1 and s.countstatus = 'A' and s.lastcountdate <= @Parm2
		AND i.StkItem = 1 AND (i.LotSerTrack = 'NN' OR i.LotSerTrack In ('LI', 'SI') AND i.SerAssign = 'R')
		AND (i.TranStatusCode <> 'IN' or @parm3 = 0)
	ORDER BY s.InvtID
GO
