USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_850Info]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDTerms_850Info] @TermsId varchar(2) As
Select TermsId, DiscPct, DiscIntrv, DiscType, DueIntrv, DueType, Descr From Terms
Where TermsId = TermsId And ApplyTo In ('B','V')
GO
