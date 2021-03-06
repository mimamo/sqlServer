USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateAccount]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateAccount]
@TwoStringList ListOfTwoStrings READONLY
AS
SELECT U.Id0, U.Id1 -- U.Id0 Is Account, U.Id1 is Function (Task)
FROM @TwoStringList U
LEFT JOIN Account A
  ON U.Id0 = A.Acct
 AND A.Active = 1
LEFT JOIN xIgFunctionCode F
  ON U.Id1 = code_ID
 AND A.Acct = F.Account
WHERE F.Account IS NULL
  AND LEN(Id1) > 0
GO
