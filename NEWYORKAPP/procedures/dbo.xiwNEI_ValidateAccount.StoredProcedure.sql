USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateAccount]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateAccount]
@StringList ListOfString READONLY
AS
SELECT U.Id
FROM @StringList U
LEFT JOIN Account A
  ON U.Id = A.Acct
 AND A.Active = 1
WHERE A.Acct IS NULL
GO
