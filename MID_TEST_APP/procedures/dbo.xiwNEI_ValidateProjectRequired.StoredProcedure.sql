USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateProjectRequired]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateProjectRequired]
@StringList ListOfString READONLY
AS
SELECT U.Id
FROM @StringList U
JOIN Account A
  ON U.Id = A.Acct
WHERE LEN(A.Acct_Cat) > 0
  AND A.Acct_Cat_SW = 1
GO
