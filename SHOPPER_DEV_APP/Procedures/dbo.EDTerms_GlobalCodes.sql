USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_GlobalCodes]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDTerms_GlobalCodes] @TermsId varchar(2) As
Select TermsBasisCode, TermsTypeCode From EDTerms Where TermsId = @TermsId And TermsType = 'G'
GO
