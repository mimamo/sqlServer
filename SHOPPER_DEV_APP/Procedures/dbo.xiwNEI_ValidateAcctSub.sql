USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateAcctSub]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateAcctSub]
@TwoStringList ListOfTwoStrings READONLY
WITH EXECUTE AS OWNER
AS
SELECT U.Id0, U.Id1
FROM @TwoStringList U
LEFT JOIN vw_acctsub S
  ON U.Id0 = S.Acct
 AND U.Id1 = S.Sub
WHERE S.Sub IS NULL
GO
