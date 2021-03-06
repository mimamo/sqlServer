USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[vi_08990CuryNPerData]    Script Date: 12/21/2015 15:55:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create View [dbo].[vi_08990CuryNPerData] as

Select

BaseCuryDec = c.DecPl,
PerToPost = a.PerNbr,
CurrYr = SUBSTRING(a.PerNbr,1, 4)

From glsetup g, currncy c, arsetup a
where g.basecuryid = c.curyid
GO
