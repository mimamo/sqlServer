USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateSubAcct]    Script Date: 12/21/2015 16:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateSubAcct]
@TwoStringList ListOfTwoStrings READONLY
AS
SELECT U.Id0, U.Id1 -- U.Id0 Is Sub, U.Id1 is Job (Project)
FROM @TwoStringList U
LEFT JOIN SubAcct S
  ON U.Id0 = S.Sub
 AND S.Active = 1
LEFT JOIN PJProj P
  ON U.Id1 = P.project
 AND S.Sub = P.gl_subacct
WHERE P.gl_subacct IS NULL
  AND LEN(Id1) > 0
GO
