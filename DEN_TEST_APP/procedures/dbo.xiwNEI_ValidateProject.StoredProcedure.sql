USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xiwNEI_ValidateProject]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xiwNEI_ValidateProject]
@StringList ListOfString READONLY
AS
SELECT U.Id
FROM @StringList U
LEFT JOIN PJProj P
  ON U.Id = P.project
 AND status_pa = 'A' 
 AND status_ap = 'A'
WHERE P.project IS NULL
GO
