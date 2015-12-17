USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_FromEDI]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDTerms_FromEDI] @DiscType varchar(1), @DiscIntrv smallint, @DiscPct float, @DueIntrv smallint As
Select Min(TermsId),Count(*) from Terms where DiscType = @DiscType and DiscIntrv = @DiscIntrv and DiscPct = @DiscPct and DueIntrv = @DueIntrv And TermsType = 'S'
GO
