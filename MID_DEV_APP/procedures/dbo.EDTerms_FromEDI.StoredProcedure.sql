USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_FromEDI]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDTerms_FromEDI] @DiscType varchar(1), @DiscIntrv smallint, @DiscPct float, @DueIntrv smallint As
Select Min(TermsId),Count(*) from Terms where DiscType = @DiscType and DiscIntrv = @DiscIntrv and DiscPct = @DiscPct and DueIntrv = @DueIntrv And TermsType = 'S'
GO
