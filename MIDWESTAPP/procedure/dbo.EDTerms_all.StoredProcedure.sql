USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDTerms_all]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDTerms_all]
 @parm1 varchar( 2 ),
 @parm2 varchar( 15 )
AS
 SELECT *
 FROM EDTerms
 WHERE TermsId LIKE @parm1
    AND CustId LIKE @parm2
 ORDER BY TermsId,
    CustId
GO
