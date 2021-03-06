USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateSubAcct]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateSubAcct]
@StringList ListOfString READONLY
AS
SELECT U.Id
FROM @StringList U
LEFT JOIN SubAcct S
  ON U.Id = S.Sub
 AND S.Active = 1
WHERE S.Sub IS NULL
GO
