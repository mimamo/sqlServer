USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_GlobalCodes]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDTerms_GlobalCodes] @TermsId varchar(2) As
Select TermsBasisCode, TermsTypeCode From EDTerms Where TermsId = @TermsId And TermsType = 'G'
GO
