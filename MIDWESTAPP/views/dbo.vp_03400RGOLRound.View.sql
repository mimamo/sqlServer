USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vp_03400RGOLRound]    Script Date: 12/21/2015 15:55:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--APPTABLE
--USETHISSYNTAX

CREATE VIEW [dbo].[vp_03400RGOLRound] AS

/****** File Name: 0320vp_03400RGOLRound.Sql				******/
/****** Created by DCR		******/
/****** Last Modified by  	******/


SELECT t.BatNbr, w.UserAddress,
	cRGOLAmtRound = ((select sum(d.tranamt * case when d.trantype = 'AD' then -1 else 1 end) from  WrkRelease w1, aptran d 
			where d.batnbr = w1.batnbr AND
 		      	w1.Module = "AP"  AND 
			d.drcr = "D")
			-
			(select sum(c.tranamt * case when c.trantype = 'AD' then -1 else 1 end) from  WrkRelease w2, aptran c 
			where c.batnbr = w2.batnbr  AND
			w2.Module = "AP" AND 
			c.drcr = "C")) 

FROM Aptran t, WrkRelease w
WHERE t.BatNbr = w.BatNbr AND w.Module = 'AP'
GO
